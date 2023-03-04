class User < ApplicationRecord
    require "securerandom"

    has_secure_password

    validates :password, presence: true
    
    
end
