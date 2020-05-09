require 'test_helper'

class UserCreateTest < ActionDispatch::IntegrationTest

  test "アカウント作成できない" do
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post users_path ,params:{user:{name: "a"*11,
                                     email: "",
                                     password: "password",
                                     password_confirmation: "invalid password"
      }}
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
  end

  test "アカウント作成できる" do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post users_path ,params:{user:{name: "example",
                                     email: "example@test.com",
                                     password: "password",
                                     password_confirmation: "password"

      }}
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end

end
