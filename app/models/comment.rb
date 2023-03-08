class Comment < ApplicationRecord
  belongs_to :post, optional: true
  belongs_to :creator, class_name: "User", foreign_key: 'creator_id'
  has_many   :replies, class_name: "Comment", foreign_key: 'comment_id'
  
  belongs_to :comment, class_name: "Comment", optional: true

  validates :content, :creator_id, presence: true

end
