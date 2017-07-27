class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcast_email
  before_create :create_activation_digest
  validates :name, length: { minimum: 5, maximum: 40 }, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, length: { minimum: 5, maximum: 140 }, 
                    presence: true, 
                    format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, presence: true, allow_nil: true
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship', 
                                  foreign_key: 'follower_id', 
                                  dependent: :destroy

  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy

  has_many :following, through: :active_relationships, 
                       source: :followed
  has_many :followers, through: :passive_relationships,
                       source: :follower

  default_scope -> { order created_at: :desc }

  has_secure_password

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def downcast_email
    self.email = email.downcase
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now 
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_activation_digest
    self.activation_token = User.new_token
    # don't use update_attribute because this way
    # activation_digest gets saved automatically 
    self.activation_digest = User.digest self.activation_token
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def password_reset_expired? 
    reset_sent_at < 2.hours.ago
  end

  def following?(user)
    following.include?(user)
  end

  def follow(user)
    following << user
  end

  def unfollow(user)
    following.delete user
  end

  def feed
    # following_ids is rails magic.
    # finds the 'following' association and appends _ids to it
    # from the 'has_many' association
    following_ids = "select followed_id from relationships 
                     where follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) 
                     or user_id = :user_id", 
                     user_id: id)
  end
end
