module ApplicationHelper
  # ビューファイルに関連するメソッドはhelperファイルに記述

  # 画像投稿で使用する
  def display_post_image(post)
    if post.post_image.attached?
      image_tag(post.post_image)
    end
  end

  # ユーザーを表示する画面で使用する
  def display_user_image(user)
    if user.user_image.attached?
      image_tag(user.user_image)
    else
      image_tag("no_image.png")
    end
  end

  # 年月日変換
  def format_datetime(datetime)
    datetime.strftime("%Y年%m月%d日 %H:%M")
  end

end