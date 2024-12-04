class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :email, presence: true

  has_many :posts

  has_one_attached :user_image
    
  def get_user_image
    if user_image.attached?
      user_image
    else
      file_path = Rails.root.join('app/assets/images/no_image.png')
      user_image.attach(io: File.open(file_path), filename: 'no_user_image.png', content_type: 'image/png')
      # 以下の文章は画像をURLとして渡すための記述
      # サインアップ時にuser_imageがデータベースに保存されていないため、URLで渡してあげないとエラーが発生する。
      Rails.application.routes.url_helpers.rails_blob_path(user_image, only_path: true)
    end
  end

  def active_for_authentication?
    super && (is_active == true)
  end
end
