class PostsController < ApplicationController
  before_action :set_post, only: %i[ show update destroy ]
  before_action :set_posts, only: %i[ index, weekly ]

  def index
    if @course.present?
        render json: @posts
    else
        render json: { msg: 'Not found course by id' }
    end
  end

  def weekly
    if @course.present?
        render json: @posts.group_by{ |p| p.created_at.beginning_of_week }
    else
        render json: { msg: 'Not found course by id' }
    end

  end

  def show
    render json: @post
  end

  def create
    post = Post.new
    post.title = post_params[:title]
    post.content = post_params[:content]
    post.course_id = post_params[:course_id]
    post.tags = Tag.find(post_params[:tags]) if post_params[:tags].present?
    post.creator_id = @current_user.id

    if post.save
      render json: post, status: :created
    else
      render json: post.errors, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def set_posts
      @course = Course.find(params[:course_id])
      tag_ids = params[:tags]
      @posts = tag_ids.present? ? @course.posts.order('created_at DESC').by_tags(tag_ids) : @course.posts.order('created_at DESC')
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content, :course_id, tags: [])
    end
end
