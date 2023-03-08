class PostSerializer < ActiveModel::Serializer
    attributes :id, :title, :content, :created_at, :updated_at
  
    has_many :comments
    belongs_to :creator
  end