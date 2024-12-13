class Admin::UsersController < ApplicationController
  def index
    @users = User.order(created_at: :desc)
  end
end










# envファイルをgit状から削除しろ