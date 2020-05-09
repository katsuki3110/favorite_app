require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:one)
    @other_user = users(:two)
  end

  test "ユーザーページ（存在しないユーザーの指定）" do
    get user_path(User.last.id + 1)
    assert_redirected_to users_path
  end

  test "ユーザー作成（パラメータ不適切）" do
    assert_no_difference 'User.count' do
      post users_path, params:{user:{name:  "name",
                                     email: "email",
                                     password:              "password",
                                     password_confirmation: "invalid"
      }}
    end
    assert_template 'new'
  end

  test "プロフィールの編集（ログインしていない）" do
    get edit_user_path(@user)
    assert_redirected_to login_path
  end

  test "プロフィールの編集（他ユーザー）" do
    log_in_as(@user)
    get edit_user_path(@other_user)
    assert_redirected_to root_path
  end


  test "プロフィールの更新（ログインしていない）" do
    patch user_path(@user),params:{user:{name:  "test",
                                         email: "test@test.com",
                                         password:              "password",
                                         password_confirmation: "password"
    }}
    assert_redirected_to login_path
  end

  test "プロフィールの更新（パラメータ不適切）" do
    log_in_as(@user)
    patch user_path(@user),params:{user:{name:         "",
                                         introduction: "a"*161
    }}
    assert_template 'edit'
  end

  test "プロフィールの更新（他ユーザー）" do
    log_in_as(@user)
    patch user_path(@other_user),params:{user:{name:  "test",
                                               email: "test@test.com",
                                               password:              "password",
                                               password_confirmation: "password"
    }}
    assert_redirected_to root_path
  end

  #一般権限によるユーザー削除
  test "ユーザー削除（ログインしてない）" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    get root_path
  end

  test "ユーザー削除（他ユーザー）" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    get root_path
  end

  test "ユーザー削除（adminユーザー）" do
    log_in_as(@user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    get root_path
  end

  #管理者によるユーザー削除権限
  test "ユーザー削除（ログインしていない）" do
    assert_no_difference 'User.count' do
      delete admin_destroy_user_path(@user)
    end
    assert_redirected_to login_path
  end

  test "ユーザー削除（adminなし）" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete admin_destroy_user_path(@user)
    end
    assert_redirected_to root_path
  end

  test "ユーザー削除（対象が存在しない）" do
    log_in_as(@user)
    assert_no_difference 'User.count' do
      delete admin_destroy_user_path(User.last.id + 1)
    end
    assert_redirected_to users_path
  end

  test "ユーザー削除（対象がログインユーザー）" do
    log_in_as(@user)
    assert_no_difference 'User.count' do
      delete admin_destroy_user_path(@user)
    end
    assert_redirected_to users_path
  end

  test "画像を編集する（ログインしていない）" do
    get edit_image_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "画像を編集する（他のユーザーでログイン）" do
    log_in_as(@other_user)
    get edit_image_user_path(@user)
    assert_redirected_to root_path
  end

  test "画像を更新する（ログインしていない）" do
    patch update_image_user_path(@user),params:{image:{image_user: "defalt.png"}}
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "画像を更新する（他のユーザーでログイン）" do
    log_in_as(@other_user)
    patch update_image_user_path(@user),params:{image:{image_user: "defalt.png"}}
    assert_redirected_to root_path
  end

  test "フォロー一覧（対象が存在しない）" do
    get following_user_path(User.last.id + 1)
    assert_redirected_to root_path
  end

  test "フォロワー一覧（対象が存在しない）" do
    get followed_user_path(User.last.id + 1)
    assert_redirected_to root_path
  end

  test "設定フォーム（ログインしていない）" do
    get setting_user_path(@user)
    assert_redirected_to login_path
  end

  test "設定フォーム（他ユーザー）" do
    log_in_as(@user)
    get setting_user_path(@other_user)
    assert_redirected_to root_path
  end

  test "設定を更新（ログインしていない）" do
    patch  update_setting_user_path(@user), params:{setting:{email: "email",
                                                             password: "password",
                                                             password_confirmation: "password"}}
    assert_redirected_to login_path
  end

  test "設定を更新（他ユーザー）" do
    log_in_as(@user)
    patch  update_setting_user_path(@other_user), params:{setting:{email: "email",
                                                                   password: "password",
                                                                   password_confirmation: "password"}}
    assert_redirected_to root_path
  end

  test "設定を更新（パラメータ不適切）" do
    log_in_as(@user)
    patch  update_setting_user_path(@user), params:{setting:{email: "invalid",
                                                             password: "password",
                                                             password_confirmation: "invalid"}}
    assert_template 'setting'
  end

end
