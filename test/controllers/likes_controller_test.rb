require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:one)
    @post = posts(:postOne)
  end

  test "いいねする（ログインしていない）" do
    assert_no_difference 'Like.count' do
      post likes_path, params:{likes:{user_id: @user.id,
                                      post_id: @post.id
      }}
    end
    assert_redirected_to login_path
  end

  test "いいね取り消す（ログインしていない）" do
    assert_no_difference 'Like.count' do
      delete like_path(@post)
    end
    assert_redirected_to login_path
  end

  test "いいね取り消す（対象のユーザが存在しない）" do
    log_in_as(@user)
    assert_no_difference 'Like.count' do
      delete like_path(Post.last.id + 1)
    end
    assert_redirected_to root_path
  end

end
