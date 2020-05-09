class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    unless current_user?(@user)
      current_user.following_relationships.create(followed_id: @user.id)
    end
    render 'follow.js.erb'
  end

  def destroy
    @user = User.find_by(id: params[:id])
    if @user.present?
      @relationship = current_user.following_relationships.find_by(followed_id: @user.id)
      @relationship.destroy
      render 'follow.js.erb'
    else
      redirect_to root_path
    end
  end

end
