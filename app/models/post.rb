class Post < ApplicationRecord
  belongs_to :user
  belongs_to :circle
  has_many :post_comments
  
  validates :body, presence: true

  has_one_attached :post_image
    
  # 画像が選択されていない場合、no_imageの画像を表示させるだけで、登録はしない。
  def get_post_image
    post_image.attached? ? post_image : "no_image.png"
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @posts = Post.where("body LIKE?", "#{word}")
    elsif search == "forward_match"
      @posts = Post.where("body LIKE?","#{word}%")
    elsif search == "partial_match"
      @posts = Post.where("body LIKE?","%#{word}%")
    else
      @posts = Post.all
    end
  end

end
