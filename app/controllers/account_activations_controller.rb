class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user.present? && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "ようこそ#{user.name}さん！！"
    else
      flash[:danger] = "このリンクは有効ではありません"
    end
    redirect_to root_path
  end

end
