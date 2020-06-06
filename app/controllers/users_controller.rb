class UsersController < ApplicationController
  before_action :logged_in_user,  only: [:edit, :update, :destroy, :edit_image, :update_image,
                                         :admin_destroy, :setting, :update_setting]
  before_action :correct_user,    only: [:edit, :update, :destroy, :edit_image, :update_image,
                                         :setting, :update_setting]
  before_action :user_admin?,     only:  :admin_destroy
  before_action :not_user_admin?, only:  :destroy

  def index
    @users = User.all.order(created_at: "DESC").page(params[:page]).per(10)
  end

  def show
    @user = User.find_by(id: params[:id])
    if @user.present?
      @posts = @user.posts.page(params[:page]).per(9)
    else
      redirect_to users_path
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "メールを送信しました。メールをご確認ください。"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(edit_params)
      flash[:success] = "プロフィールを更新しました！"
      redirect_to user_path
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:info] = "退会しました"
    logout
    redirect_to root_path
  end

  def admin_destroy
    @user = User.find_by(id: params[:id])
    if @user.present? && !current_user?(@user)
      @user.destroy
      flash[:info] = "削除しました"
    end
    redirect_to users_path
  end

  def edit_image
  end

  def update_image
    if @user.update(image_params)
      flash[:success] = "画像を更新しました"
      redirect_to user_path(@user)
    else
      render 'edit_image'
    end
  end

  def following
    @title = 'フォロー'
    users = User.find_by(id: params[:id])
    if users.present?
      @users = users.followings.page(params[:page]).per(10)
      render 'index'
    else
      redirect_to root_path
    end
  end

  def followed
    @title = 'フォロワー'
    users  = User.find_by(id: params[:id])
    if users.present?
      @users = users.followers.page(params[:page]).per(10)
      render 'index'
    else
      redirect_to root_path
    end
  end

  def serch
    users = User.where('name LIKE ?', "%#{params[:name]}%")
    @users = users.order(created_at: "DESC").page(params[:page]).per(10)
    @serch = params[:name]
    render 'index'
  end

  def setting
  end

  def update_setting
    if @user.update(setting_params)
      flash[:success] = "設定を変更しました！"
      redirect_to root_path
    else
      render 'setting'
    end
  end


  private

    def user_params
      params.require(:user).permit(:name,
                                   :email,
                                   :password,
                                   :password_confirmation)
    end

    def edit_params
      params.require(:user).permit(:name, :introduction)
    end

    def image_params
      params.require(:image).permit(:image_user)
    end

    def setting_params
      params.require(:setting).permit(:email,
                                      :password,
                                      :password_confirmation)
    end

    def correct_user
      @user = User.find_by(id: params[:id])
      redirect_to root_path if @user.nil? || !current_user?(@user)
    end

    def user_admin?
      redirect_to root_path unless current_user.admin?
    end

    def not_user_admin?
      redirect_to root_path if current_user.admin?
    end

end
