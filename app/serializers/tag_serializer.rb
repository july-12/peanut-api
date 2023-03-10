class TagSerializer < ActiveModel::Serializer
    attributes :id, :name, :color

    has_many :posts, serializer: PostPreviewSerializer
  end