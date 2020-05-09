require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:one)
    @other_user = users(:two)
  end

  test "記事詳細ページ表示（対象が存在しない）" do
    get post_path(Post.last.id + 1)
    assert_redirected_to root_path
  end

  test "投稿フォーム（ログインしていない）" do
    get new_post_path
    assert_redirected_to login_path
  end

  test "投稿する（ログインしていない）" do
    assert_no_difference 'Post.count' do
      assert_no_difference 'Spot.count' do
        post posts_path, params:{post:{title: "postTest",
                                       place: "postPlace",
                                       image_post: "default.png",
                                       overview:   "overview",
                                       spots_attributes: [{place: "spot",
                                                           image_spot: "spot.png",
                                                           explaine: "text"}]
        }}
      end
    end
    assert_redirected_to login_path
  end

  test "投稿する（パラメータ不適切）" do
    log_in_as(@user)
    assert_no_difference 'Post.count' do
      assert_no_difference 'Spot.count' do
        post posts_path, params:{post:{title: "",
                                       place: "postPlace",
                                       image_post: "default.png",
                                       overview: "",
                                       spots_attributes: [{place: "spot",
                                                           image_spot: "spot.png",
                                                           explaine: "text"}]
        }}
      end
    end
    assert_template 'new'
  end

  test "編集フォーム（ログインしていない）" do
    get edit_post_path(@user.posts.first)
    assert_redirected_to login_path
  end

  test "編集フォーム（他ユーザーの記事）" do
    log_in_as(@user)
    get edit_post_path(@other_user)
    assert_redirected_to root_path
  end

  test "編集する（ログインしていない）" do
    assert_no_difference 'Post.count' do
      assert_no_difference 'Spot.count' do
        patch post_path(@user.posts.first), params:{post:{title: "Title",
                                                          place: "postPlace",
                                                          image_post: "default.png",
                                                          overview:   "overview",
                                                          spots_attributes: [{place: "spot1",
                                                                              image_spot: "spot1.png",
                                                                              explaine: "text1"}]
        }}
      end
    end
    assert_redirected_to login_path
  end

  test "編集する（他ユーザーの記事）" do
    log_in_as(@user)
    assert_no_difference 'Post.count' do
      assert_no_difference 'Spot.count' do
        patch post_path(@other_user.posts.first), params:{post:{title: "Title",
                                                                place: "postPlace",
                                                                image_post: "default.png",
                                                                overview:   "overview",
                                                                spots_attributes: [{place: "spot1",
                                                                                    image_spot: "spot1.png",
                                                                                    explaine: "text1"}]
        }}
      end
    end
    assert_redirected_to root_path
  end

  test "編集する（パラメータ不適切）" do
    log_in_as(@user)
    assert_no_difference 'Post.count' do
      assert_no_difference 'Spot.count' do
        patch post_path(@user.posts.first), params:{post:{title: "",
                                                          place: "postPlace",
                                                          image_post: "default.png",
                                                          overview:   "",
                                                          spots_attributes: [{place: "spot",
                                                                              image_spot: "spot.png",
                                                                              explaine: "text"}]
        }}
      end
    end
    assert_template 'edit'
  end

  test "削除する（ログインしていない）" do
    assert_no_difference 'Post.count' do
      assert_no_difference 'Spot.count' do
        delete post_path(@user.posts.first)
      end
    end
    assert_redirected_to login_path
  end

  test "削除する（他ユーザーの記事）" do
    log_in_as(@user)
    assert_no_difference 'Post.count' do
      assert_no_difference 'Spot.count' do
        delete post_path(@other_user.posts.first)
      end
    end
    assert_redirected_to root_path
  end

end
