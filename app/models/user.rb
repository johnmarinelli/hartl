class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name, length: { minimum: 5, maximum: 20 }, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, length: { minimum: 5, maximum: 140 }, 
                    presence: true, 
                    format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, presence: true
  has_many :microposts

  has_secure_password
end
