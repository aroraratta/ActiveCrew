class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :email, presence: true

  has_one_attached :user_image
    
  def get_user_image
    unless user_image.attached?
      file_path = Rails.root.join('app/assets/images/no_user_image.png')
      user_image.attach(io: File.open(file_path), filename: 'no_user_image.png', content_type: 'image/png')
    else
      user_image
    end
  end
end
