class Public::PostsController < ApplicationController
  before_action :authenticate_user_or_admin!, only: [:update]
  before_action :authenticate_user!, except: [:update]
  before_action :ensure_post, except: [:new, :create]

  def new
    @post = Post.new
    @circles = current_user.circles
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "投稿しました"
      redirect_to mypage_path
    else
      render :new
    end
  end

  def show
    @circles = @post.user.circles
    @post_comment = PostComment.new
    @post_comments = @post.post_comments.order(created_at: :desc)
  end

  def update
    @circles = @post.user.circles
    if @post.update(post_params)
      flash.now[:notice] = "投稿を編集しました"
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to mypage_path
  end

  private
  
  def ensure_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:body, :circle_id, :post_image)
  end
end