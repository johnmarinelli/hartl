class User < ApplicationRecord
  validates :email, length: { minimum: 5, maximum: 140 }, presence: true
  validates :name, length: { minimum: 5, maximum: 20 }, presence: true
  has_many :microposts
end
