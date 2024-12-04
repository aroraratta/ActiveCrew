class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_post, except: [:new, :create]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "投稿成功"
      redirect_to post_path(@post)
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  
  def ensure_post
    @post = Post.find(params[:id])
  end
end

  def post_params
    params.require(:post).permit(:body, :post_image)
  end
