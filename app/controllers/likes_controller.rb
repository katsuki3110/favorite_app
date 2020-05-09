class LikesController < ApplicationController
  before_action :logged_in_user

  def create
    @like = current_user.likes.create(post_id: params[:post_id])
    @post = Post.find(params[:post_id])
    render 'like.js.erb'
  end

  def destroy
    @like = current_user.likes.find_by(post_id: params[:id])
    if @like.present?
      @like.destroy
      @post = Post.find(params[:id])
      render 'like.js.erb'
    else
      redirect_to root_path
    end
  end

end
