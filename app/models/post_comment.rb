class PostComment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  
  # コメントに画像は添付しないが、app/views/publics/posts/_index.html.erbの27行目の条件分岐のため記述
  has_one_attached :post_image
  
  validates :comment, presence: true
end
