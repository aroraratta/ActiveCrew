class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  before_action :ensure_post, except: [:index]
  
  def index
    @posts = Post.order(created_at: :desc)
  end
  
  def show
    @post_comment = PostComment.new
    @post_comments = @post.post_comments.order(created_at: :desc)
  end
  
  def update
    if @post.update(post_params)
      flash[:notice] = "投稿を編集しました"
      redirect_to admin_post_path(@post)
    else
      @post_comment = PostComment.new
      @post_comments = @post.post_comments.order(created_at: :desc)
      render :show
    end
  end
  
  def destroy
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to admin_user_path(@post.user)
  end

  private
  
  def ensure_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:body, :post_image)
  end

end
