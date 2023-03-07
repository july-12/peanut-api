class Post < ApplicationRecord
  belongs_to :course
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  has_many :comments

  validates :title, presence: true
  validates :course_id, presence: true
  validates :creator_id, presence: true

end
