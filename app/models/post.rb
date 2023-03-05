class Post < ApplicationRecord
  belongs_to :course

  validates :title, presence: true
  validates :course_id, presence: true
  validates :creator_id, presence: true

end
