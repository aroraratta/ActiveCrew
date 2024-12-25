class Circle < ApplicationRecord
  has_many :circle_users, dependent: :destroy
  has_many :users, through: :circle_users
  has_many :posts, dependent: :destroy
  has_many :permits, dependent: :destroy
  
  belongs_to :owner, class_name: "User"
  belongs_to :city
  belongs_to :prefecture
  
  validates :circle_name, presence: true

  has_one_attached :circle_image

  # homes/topで使用する
  scope :top_3_by_posts, -> {
    select("circles.*, COUNT(posts.id) AS posts_count")
    .joins(:posts)
    .group("circles.id")
    .order("posts_count DESC")
    .limit(3)
  }
  
  scope :top_3_by_members, -> {
    joins(:circle_users)
      .select("circles.*, COUNT(circle_users.id) AS members_count")
      .group("circles.id")
      .order("members_count DESC")
      .limit(3)
  }

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

  def owner?(user)
    user.id == owner_id
  end

  def user_count
    users.where(is_active: true).count
  end
  
  def post_count
    posts.joins(:user).where(users: { is_active: true }).count
  end

end
