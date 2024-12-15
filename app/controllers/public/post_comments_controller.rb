class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user_or_admin!, except: [:create]

  def create
    post = Post.find(params[:post_id])
    comment = current_user.post_comments.new(post_comment_params)
    comment.post_id = post.id
    if comment.save
      flash[:notice] = "コメントしました"
      redirect_to post_path(post)
    else
      flash[:alert] = "コメントに失敗しました。"
      redirect_to post_path(post)
    end
  end

  def update
    if admin_signed_in?
      user = Post.find(params[:post_id]).user
      route = admin_post_path(params[:post_id])
    else
      user = current_user
      route = post_path(params[:post_id])
    end
  
    comment = user.post_comments.find(params[:id])
    if comment.update(post_comment_params)
      flash[:notice] = "コメントを編集しました"
      redirect_to post_path(params[:post_id])
    else
      flash[:alert] = "編集に失敗しました"
      redirect_to route
    end
  end 
  
  def destroy
    PostComment.find(params[:id]).destroy
    flash[:notice] = "コメントを削除しました"
    if admin_signed_in?
      redirect_to admin_post_path(params[:post_id])
    else
      redirect_to post_path(params[:post_id])
    end
  end 

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
