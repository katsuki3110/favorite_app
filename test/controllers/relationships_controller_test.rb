require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:one)
    @other_user = users(:two)
  end

  test "フォローする（ログインしていない）" do
    assert_no_difference 'Relationship.count' do
      post relationships_path(followed_id: @other_user.id)
    end
    assert_redirected_to login_path
  end

  test "フォローする（対象が自分）" do
    log_in_as(@user)
    assert_no_difference 'Relationship.count' do
      post relationships_path(followed_id: @user.id)
    end
    assert_template 'follow.js.erb'
  end

  test "フォロー取り消し（ログインしていない）" do
    assert_no_difference 'Relationship.count' do
      delete relationship_path(@other_user)
    end
    assert_redirected_to login_path
  end

  test "フォロー取り消し（対象が存在しない）" do
    log_in_as(@user)
    assert_no_difference 'Relationship.count' do
      delete relationship_path(User.last.id + 1)
    end
    assert_redirected_to root_path
  end

end
