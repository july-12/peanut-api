class Course < ApplicationRecord
    has_many :posts

    validates :title, presence: true
    validates :creator_id, presence: true
end
