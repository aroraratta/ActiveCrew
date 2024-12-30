class Circle < ApplicationRecord
  has_many :circle_users, dependent: :destroy
  has_many :users, through: :circle_users
  has_many :posts, dependent: :destroy
  has_many :permits, dependent: :destroy
  has_many :events, dependent: :destroy
  
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
  
  # homes/topで使用する
  scope :top_3_by_members, -> {
    joins(:circle_users)
      .select("circles.*, COUNT(circle_users.id) AS members_count")
      .group("circles.id")
      .order("members_count DESC")
      .limit(3)
  }

  # 検索機能にて使用する
  SEARCH_COLUMNS = %w[circle_name circle_introduction].freeze
  def self.looks(search, word)
    case search
    when "perfect_match"
      query = SEARCH_COLUMNS.map { |col| "#{col} = :word" }.join(" OR ")
      where(query, word: word)
    when "forward_match"
      query = SEARCH_COLUMNS.map { |col| "#{col} LIKE :word" }.join(" OR ")
      where(query, word: "#{word}%")
    when "partial_match"
      query = SEARCH_COLUMNS.map { |col| "#{col} LIKE :word" }.join(" OR ")
      where(query, word: "%#{word}%")
    else
      all
    end
  end

  # サークル検索時に県と市を含めて検索する
  def self.looks_with_location(search, word, prefecture_id = nil, city_id = nil)
    results = looks(search, word)
    results = results.joins(:city).where(cities: { prefecture_id: prefecture_id }) if prefecture_id.present?
    results = results.where(city_id: city_id) if city_id.present?
    results
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
