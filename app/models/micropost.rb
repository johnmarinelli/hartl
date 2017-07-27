class Micropost < ApplicationRecord
  validates :content, length: { maximum: 140 }, presence: true
  validates :user_id, presence: true
  validate :picture_size
  default_scope -> { order(created_at: :desc) }

  # carrierwave method to associate image with model
  mount_uploader :picture, PictureUploader
  belongs_to :user

  private
    
    # validates size of an uploaded picture
    def picture_size
      if picture.size > 5.megabytes
        errors.add :picture, 'Should be less than 5MB'
      end
    end


end
