class User < ApplicationRecord

  has_many :spots
  has_one_attached :image_name
  has_many :likes, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  validates :name, presence: true #名前記入必須

  mount_uploader :image_name, ImageUploader

  attr_accessor :current_password
end
