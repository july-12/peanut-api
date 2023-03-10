class Tag < ApplicationRecord
    validates :name, presence: true, uniqueness: { scope: :course_id, case_sensitive: false }

    belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
    belongs_to :course

    has_many :tag_posts
    has_many :posts, through: :tag_posts
end
