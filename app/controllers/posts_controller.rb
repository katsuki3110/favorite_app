class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]

  def index
    user = User.find_by(id: params[:user_id])
    @flg = params[:flg]
    if user.present? && @flg == "1"
      #投稿記事タブを押下した場合
      @posts = user.posts.order(created_at: "DESC").page(params[:page]).per(9)
    elsif user.present? && params[:flg] == "2"
      #お気に入り記事タブを押下した場合
      @posts = user.like_posts.order(created_at: "DESC").page(params[:page]).per(9)
    else
      #タイムライン
      @posts = Post.all.order(created_at: "DESC").page(params[:page]).per(18)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @post = Post.find_by(id:params[:id])
    if @post.present?
      @spots = @post.spots
    else
      redirect_to root_path
    end
  end

  def new
    @post = Post.new
    @post.spots.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:info] = "投稿しました"
      redirect_to post_path(@post)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:info] = "更新しました"
      redirect_to post_path(@post)
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    flash[:info] = "記事が削除されました"
    redirect_to posts_path
  end

  def serch
    posts = Post.where('place LIKE ?', "%#{params[:place]}%")
    @posts = posts.order(created_at: "DESC").page(params[:page]).per(18)
    @serch = params[:place]
    render 'index'
  end


  private

    def post_params
      params.require(:post).permit(:title,
                                   :place,
                                   :image_post,
                                   :overview,
                                   spots_attributes:[:id,
                                                     :place,
                                                     :image_spot,
                                                     :explaine,
                                                     :_destroy]
      )
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_path if @post.nil?
    end

end
