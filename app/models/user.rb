class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :email, presence: true

  has_many :posts
  has_many :post_comments
  has_many :circle_users, dependent: :destroy
  has_many :circles, through: :circle_users
  has_many :permits, dependent: :destroy
  has_many :groups,through: :group_users
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :rooms, through: :entries
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower

  has_one_attached :user_image

  def active_for_authentication?
    super && (is_active == true)
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name = ? OR introduction = ?", word, word)
    elsif search == "forward_match"
      @user = User.where("name LIKE ? OR introduction LIKE ?", "#{word}%", "#{word}%")
    elsif search == "partial_match"
      @user = User.where("name LIKE ? OR introduction LIKE ?", "%#{word}%", "%#{word}%")
    else
      @user = User.all
    end
  end

  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  
  def following?(user)
    followings.include?(user)
  end

end
