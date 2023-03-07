class CommentsController < ApplicationController
    def index
        post = Post.find(params[:post_id])
        if post.present?
            comments = post.comments.limit(10)
            render json: { list: comments, total: comments.count }
        else
            render json: { msg: 'post not found' }
        end
    end

    def create
        comment = Comment.new(post_params)
        comment.creator_id = @current_user.id

        if comment.save
        render json: comment, status: :created
        else
        render json: comment.errors, status: :unprocessable_entity
        end
    end

    private
        def post_params
        params.require(:comment).permit(:post_id, :comment_id, :content)
        end
end
