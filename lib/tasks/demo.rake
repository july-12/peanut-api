namespace :db do
  namespace :seed do
    task :transform => :environment do
      dataPath = "originData"

      user = User.find_or_create_by(name: "pizza") do |user|
        user.password = "123456a"
        user.password_confirmation = "123456a"
      end

      # 匿名用户
      anonymous = User.find_or_create_by(name: "Xxxxxxx") do |user|
        user.password = "123456a"
        user.password_confirmation = "123456a"
      end

      course = Course.find_or_create_by(title: "pizza") do |course|
        course.creator = user
      end

      piazza_feed_file = "#{Rails.root}/#{dataPath}/piazza_my_feed.json"
      piazza_post_file = ->id { "#{Rails.root}/#{dataPath}/piazza-data/#{id}.json" }

      def content_to_rich_text(content)
        return "" if content.nil?

        content.gsub!(/(<md>[\s\S]+?<\/md>)/m) do |md|
          CommonMarker.render_html(
            Nokogiri::HTML.parse(
              md
                .delete_prefix("<md>")
                .delete_suffix("</md>")
                .gsub(/<br \/>/, "\n")
            ).text, :DEFAULT
          )
            .tap { }
        end
        content
      end

      # def create_comment(commentable, comment_json)
      #   commentable.comments.create!(
      #     rich_content: comment_content(comment_json),
      #     created_at: comment_json["created"],
      #     updated_at: comment_json["updated"],
      #     raw_comment: comment_json,
      #     type: comment_json["type"],
      #     content_type: "rich_content",
      #   )
      # end

      def comment_content(comment_json)
        content = ""
        if comment_json["type"] == "s_answer"
          if comment_json["history"]
            content = content_to_rich_text(comment_json["history"][0]["content"])
          end
        else
          content = content_to_rich_text(comment_json["subject"])
        end
        content
      end

      def parse_html_entities(content)
        Nokogiri::HTML.parse(content).text
      end

      def img_to_attachment(record, attr_name)
        rich_text = record.send(attr_name)
        if rich_text && rich_text.body.to_s =~ /(<img src="(\S+)?".+?>)/
          body = rich_text.body.to_html
          body.scan(/(<img src="(\S+)?".+?>)/).each do |tag, path|
            if path.start_with?("/redirect/")
              uri = path
              path = "/img/#{SecureRandom.uuid}.#{path.split(".")[-1]}"
              puts uri
              `curl -o "#{Rails.root}/data#{path}" -L "https://piazza.com#{uri}"`
            end
            if File.exist?("#{Rails.root}/data#{path}")
              filename = File.basename(path)
              blob = ActiveStorage::Blob.create_and_upload!(
                io: File.open("#{Rails.root}/data#{path}"),
                filename: filename,
              )
              blob.analyze
              image_path = Rails.application.routes.url_helpers.rails_blob_path(blob, only_path: true)
              attachment = ActionText::Attachment.from_attachable(blob)

              body.gsub!(tag, attachment.to_html)  # .gsub(/(filename=\"#{filename}\")/, " url=\"#{image_path}\" #{$1} ")
            end
          end
          rich_text.update(body: ActionText::Content.new(body))
        end
      end

      if File.exist?(piazza_feed_file)
        piazza_feed = File.read(piazza_feed_file)

        # JsonPath.on(piazza_feed, "$.result.tags.instructor_upd")[0].each do |title, uid|
        #   Tag.find_or_create_by(name: title, uid: uid) do |tag|
        #     tag.name = title
        #     tag.uid = uid
        #     tag.course = course
        #     tag.creator = user
        #   end
        # end

        # feed = JsonPath.on(piazza_feed, "$.result.feed[*]")[0]
        JsonPath.on(piazza_feed, "$.result.feed[*]").each do |feed|
          post_id = feed["nr"]

          post_json =
            if File.exist? piazza_post_file[post_id]
              File.read(piazza_post_file[post_id])
            end || "{}"

          Post.find_or_initialize_by(uid: post_id).tap do |post|
            post.title = Nokogiri::HTML.parse(feed["subject"]).text
            post.content = content_to_rich_text(JsonPath.on(post_json, "$.result.history[0].content")[0])
            # rich_content: content_to_rich_text(JsonPath.on(post_json, "$.result.history[0].content")[0]),
            # folder_list: feed["folders"].map { |it| parse_html_entities(it) },
            # tag_list: feed["tags"].map { |it| parse_html_entities(it) },
            # raw_feed: feed,
            # raw_post: JSON.parse(post_json),
            post.uid = post_id
            # type: feed["type"],
            post.created_at = JsonPath.on(post_json, "$.result.created")[0]
            post.updated_at = JsonPath.on(post_json, "$.result.change_log[-1].when")[0]
            # pin: feed["tags"].include?("pin"),
            # instructor_note: feed["tags"].include?("instructor-note"),
            # content_type: "rich_content",
            post.tags = Tag.where(name: feed["folders"])
            post.course = course
            post.creator = user
            post.save
            JsonPath.on(post_json, "$.result.children[*]").each do |comment_json|
              post.comments.find_or_create_by(uid: comment_json["uid"]).tap do |comment|
                comment.creator = anonymous
                comment.content = comment_content(comment_json)
                comment.created_at = comment_json["created"]
                comment.updated_at = comment_json["updated"] ? comment_json["updated"] : Time.now
                comment.save

                if comment_json["children"].any?
                  comment_json["children"].each do |reply_json|
                    comment.replies.find_or_create_by(uid: reply_json["uid"]).tap do |reply|
                      reply.creator = anonymous
                      reply.content = comment_content(reply_json)
                      reply.created_at = reply_json["created"]
                      reply.updated_at = reply_json["updated"] ? reply_json["updated"] : Time.now
                      reply.save
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
