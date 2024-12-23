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
      flash[:alert] = "コメントに失敗しました"
      redirect_to post_path(post)
    end
  end

  def update
    route = post_path(params[:post_id])
    post = Post.find(params[:id])
    @comment = current_user.post_comments.find(params[:id])
    if @comment.update(post_comment_params)
      @post_comments = post.post_comments.order(created_at: :desc)
      flash[:notice] = "コメントを編集しました"
      redirect_to post_path(params[:post_id])
    else
      flash[:alert] = "コメントの編集に失敗しました"
      redirect_to post_path(params[:post_id])
    end
    # updateの非同期通信化は最後に実装
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
