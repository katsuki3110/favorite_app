require 'test_helper'

class UserIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin     = users(:one)
    @non_admin = users(:two)
  end

  test "ユーザー一覧の表示（adminでログイン）" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    first_page_of_users = User.page(1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user)
      unless user == @admin
        assert_select 'a[href=?]', admin_destroy_user_path(user)
      end
    end
    assert_difference 'User.count', -1 do
      delete admin_destroy_user_path(@non_admin)
    end
  end

  test "ユーザー一覧の表示（non-adminでログイン）" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: '削除', count: 0
  end
end
