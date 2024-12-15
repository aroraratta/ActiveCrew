module Admin::UsersHelper
  def user_status_title(user)
    if user.is_active
      content_tag(:h3, "有効ユーザー", class: "page-title my-auto")
    else
      content_tag(:h3, "退会ユーザー", class: "page-title-gray my-auto")
    end
  end

end
