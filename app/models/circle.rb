class Circle < ApplicationRecord
  validates :circle_name, presence: true

  has_many :circle_users, dependent: :destroy
  has_many :users, through: :circle_users
  has_many :posts, dependent: :destroy
  
  belongs_to :owner, class_name: "User"
  belongs_to :city
  belongs_to :prefecture

  has_one_attached :circle_image

  def self.looks(search, word)
    if search == "perfect_match"
      @circle = Circle.where("circle_name = ? OR circle_introduction = ?", word, word)
    elsif search == "forward_match"
      @circle = Circle.where("circle_name LIKE ? OR circle_introduction LIKE ?", "#{word}%", "#{word}%")
    elsif search == "partial_match"
      @circle = Circle.where("circle_name LIKE ? OR circle_introduction LIKE ?", "%#{word}%", "%#{word}%")
    else
      @circle = Circle.all
    end
  end
end
