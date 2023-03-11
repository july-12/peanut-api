class Post < ApplicationRecord
  validates :title, :course_id, :creator_id, presence: true

  belongs_to :course
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  has_many :comments
  # has_many :tag_posts
  # has_many :tags, through: :tag_posts
  has_and_belongs_to_many :tags, join_table: 'tag_posts'

  # scope :by_tags ->(tags) { joins(:tags).where(id: tags)}
  scope :by_tags, ->(tags) {
    joins(:tags).where(tags: { id: tags }).uniq { |p| p.id }
  }

end
