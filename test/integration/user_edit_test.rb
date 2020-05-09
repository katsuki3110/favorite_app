require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "編集する（失敗）" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              introduction: "introduction" }}
    assert_template 'users/edit'
  end

  test "編集する（成功）" do
    log_in_as(@user)
    get edit_user_path(@user)
    name  = "name"
    introduction = "introduction"
    patch user_path(@user), params: { user: { name:         name,
                                              introduction: introduction} }
    assert_not flash.empty?
    assert_redirected_to user_path(@user)
    @user.reload
    assert_equal name,         @user.name
    assert_equal introduction, @user.introduction
  end
end
