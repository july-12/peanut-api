class Course < ApplicationRecord
  has_many :posts
  has_many :tags
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"

  validates :title, presence: true
  validates :creator_id, presence: true
end
