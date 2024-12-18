class Circle < ApplicationRecord
  validates :circle_name, presence: true

  has_many :circle_users, dependent: :destroy
  has_many :users, through: :circle_users
  has_many :circle_addresses, dependent: :destroy
  has_many :posts, dependent: :destroy
  
  belongs_to :owner, class_name: "User"
  belongs_to :city
  belongs_to :prefecture

  has_one_attached :circle_image
end
