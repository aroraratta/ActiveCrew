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
  
  # サークルを表示する画面で使用する
  def display_circle_image(circle)
    if circle.circle_image.attached?
      image_tag(circle.circle_image)
    else
      image_tag("no_image.png")
    end
  end

  # 年月日変換
  def format_datetime(datetime)
    datetime.strftime("%Y年%m月%d日 %H:%M")
  end

  # is_activeがtrueのユーザーの取得(複数ユーザーある場合に使用)
  def first_active_user(user)
    users.where.not(id: user.id).where(is_active: true).first
  end

end