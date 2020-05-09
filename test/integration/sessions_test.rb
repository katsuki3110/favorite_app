require 'test_helper'

class SessionsTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:one)
  end

  test "ログイン成功する" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params:{session:{email: @user.email,
                                       password: "password"
    }}
    assert is_logged_in?
    assert_redirected_to root_path
  end

  test "ログイン失敗する" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params:{session:{email: @user.email,
                                       password: "invalid"
    }}
    assert_not is_logged_in?
    assert_template 'sessions/new'
  end

end
