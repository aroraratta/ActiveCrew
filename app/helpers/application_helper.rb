module ApplicationHelper
  # ビューファイルに関連するメソッドはhelperファイルに記述

  # 画像投稿で使用する
  def display_post_image(post)
    if post.post_image.attached?
      image_tag(post.post_image)
    end
  end

end