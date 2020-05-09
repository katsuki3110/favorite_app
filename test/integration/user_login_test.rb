require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:one)
  end

  test "ログインする（パスワード間違い）" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email:    @user.email,
                                          password: "invalid" } }
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?
  end

  test "ログインして、ログアウトする" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'home/top'
    assert_select "a[href=?]", new_post_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", setting_user_path(@user)
    assert_select "a[href=?]", new_user_path, count: 0
    assert_select "a[href=?]", login_path,    count: 0
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_path
    follow_redirect!
    assert_select "a[href=?]", new_post_path,            count: 0
    assert_select "a[href=?]", user_path(@user),         count: 0
    assert_select "a[href=?]", logout_path,              count: 0
    assert_select "a[href=?]", setting_user_path(@user), count: 0
    assert_select "a[href=?]", new_user_path
    assert_select "a[href=?]", login_path
  end

  test "ログインする（資格情報の保持）" do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies[:remember_token]
  end

  test "ログインする（資格情報の保持しない）" do
    # cookieを保存してログイン
    log_in_as(@user, remember_me: '1')
    delete logout_path
    # cookieを削除してログイン
    log_in_as(@user, remember_me: '0')
    assert_empty cookies[:remember_token]
  end

end
