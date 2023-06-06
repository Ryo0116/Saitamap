class Spot < ApplicationRecord
  
  belongs_to :user
  has_many :likes, dependent: :destroy
  mount_uploader :image_name, ImageUploader

  def liked?(user)
    likes.where(user_id: user.id).exists?
  end
end
