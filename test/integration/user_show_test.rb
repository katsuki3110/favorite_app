require 'test_helper'

class UserShowTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:one)
    @other_user = users(:two)
  end

  test "profile display" do
    log_in_as(@user)
    #自分のプロフィール
    get user_path(@user)
    assert_select 'a[href=?]', edit_user_path
    #自分以外のプロフィール
    get user_path(@other_user)
    assert_template 'relationships/_follow_form'
  end

end
