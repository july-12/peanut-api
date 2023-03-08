class CommentsController < ApplicationController
    def index
        post = Post.find(params[:post_id])
        if post.present?
            comments = post.comments.limit(10)
            render json: comments, each_serializer: CommentSerializer
        else
            render json: { msg: 'post not found' }
        end
    end

    def create
        comment = Comment.new(comment_params)
        comment.creator = @current_user

        if comment.save
        render json: comment, status: :created
        else
        render json: comment.errors, status: :unprocessable_entity
        end
    end

    private
        def comment_params
        params.require(:comment).permit(:post_id, :comment_id, :content)
        end
end
