class TagsController < ApplicationController
    def index
        @course = Course.find(params[:course_id])
        if @course.present?
            render json: @course.tags
        else 
            render json: { msg: 'Not found course by id' }
        end
    end

    def create
        tag = Tag.new(tag_params)
        if !tag.color.present? 
            tag.color = "#" + "%06x" % (rand * 0xffffff)
        end
        tag.creator = @current_user

        if tag.save
            render json: tag, status: :created
        else
            render json: tag.errors, status: :unprocessable_entity
        end
    end

    def batch
        # TODO: has uniqueness issue unique_by: :name, 
        tags = Tag.insert_all!(tags_params[:tags], returning: %w[ id name ])
        if tags.present?
            render json: tags#, serializer: TagPreviewSerializer
        else
            render json: tags.errors
        end
    end

    private
        def tag_params
            params.require(:tag).permit(:name, :course_id, :color)
        end
        def tags_params
            params.permit(tags: [:name, :course_id])
        end
end
