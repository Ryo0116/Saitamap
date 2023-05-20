class Spot < ApplicationRecord
  
  belongs_to :user

  mount_uploader :image_name, ImageUploader
end
