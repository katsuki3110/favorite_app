require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:one)
  end

  test "ログイン（アドレスが不正）" do
    post login_path, params:{session:{email: "",
                                      password: "password"
    }}
    assert_template 'new'
  end

  test "ログイン（パスワードが不正）" do
    post login_path, params:{session:{email: "example@test.com",
                                      password: "invalid"
    }}
    assert_template 'new'
  end

  test "ログイン（アカウントが有効になっていない）" do
    post login_path, params:{session:{email: "example@test.com",
                                      password: "password",
                                      activated: false
    }}
    assert_template 'new'
  end

  test "ログアウト（ログインしていない）" do
    delete logout_path
    assert_redirected_to login_path
  end

end
