class CommentSerializer < ActiveModel::Serializer
    attributes :id, :content, :created_at, :updated_at

    has_many :replies
    belongs_to :creator
end