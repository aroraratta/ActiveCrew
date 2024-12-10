class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :ensure_post, except: [:new, :create]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "投稿しました"
      redirect_to mypage_path(@post)
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "投稿を編集しました"
      redirect_to post_path(@post)
    else
      render :edit
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
end

  def post_params
    params.require(:post).permit(:body, :post_image)
  end
