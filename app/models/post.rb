class Post < ApplicationRecord
  belongs_to :user
  
  validates :body, presence: true

  has_one_attached :post_image
    
  # 画像が選択されていない場合、no_imageの画像を表示させるだけで、登録はしない。
  def get_post_image
    post_image.attached? ? post_image : "no_image.png"
  end
end
