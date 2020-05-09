class SessionsController < ApplicationController
  before_action :logged_in_user, only: :destroy

  def new
  end

  def create
    user = User.find_by(email:params[:session][:email])
    if user.present? && user.authenticate(params[:session][:password])
      if user.activated?
        flash[:success] = "ログインしました!"
        log_in user
        params[:session][:remember_me] == "1"? remember(user):forget(user)
      else
        flash[:danger] = "アカウントが有効になっていません。メールをご確認ください。"
      end
      redirect_to root_path
    else
      flash.now[:danger] = "メールアドレスまたはパスワードが間違っています"
      render 'new'
    end
  end

  def destroy
    logout
    flash[:info] = "ログアウトしました"
    redirect_to root_path
  end

end
