class SearchesController < ApplicationController

  def search
    @range = params[:range]
    if @range == "user"
      @users = User.looks(params[:search], params[:word])
    elsif @range == "post"
      @posts = Post.looks(params[:search], params[:word])
    end
  end

end
