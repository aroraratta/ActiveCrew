class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def authenticate_user_or_admin!
    unless admin_signed_in? || user_signed_in?
      flash[:alert] = "ログインしてください。"
      redirect_to new_user_session_path
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  GUEST_USER_EMAIL = "guest@example.com"

  def reset_guest_data
    guest_user = User.find_by(id: 1)
    User.transaction do
      guest_user.posts.destroy_all if guest_user.posts.any?
      guest_user.post_comments.destroy_all if guest_user.post_comments.any?
      guest_user.permits.destroy_all if guest_user.permits.any?
      guest_user.circles.destroy_all if guest_user.circles.any?
      guest_user.messages.destroy_all if guest_user.messages.any?
      guest_user.rooms.destroy_all if guest_user.rooms.any?
      guest_user.followings.destroy_all if guest_user.followings.any?
      guest_user.followers.destroy_all if guest_user.followers.any?
      guest_user.attends.destroy_all if guest_user.attends.any?
  
      guest_user.update(
        email: GUEST_USER_EMAIL,
        name: "ゲストユーザー",
        introduction: "ゲストユーザーでログイン中です。各種機能をお試しください。(ゲストユーザーで行った投稿はログアウト後に削除されます。)",
        is_active: true
      )

      puts guest_user.errors.full_messages # エラー内容を出力
    end
  end
end
