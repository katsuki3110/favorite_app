require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "test",
                     email: "test@test.com",
                     password: "password",
                     password_confirmation: "password"
    )
  end

  test "nameは最大10文字である" do
    @user.name = "a" * 11
    assert_not @user.valid?
  end

  test "emailは空白でない" do
    @user.email = "  "
    assert_not @user.valid?
  end

  test "emailは一意である" do
    other_user = @user.dup
    @user.save
    assert_not other_user.valid?
  end

  test "passwordは空白でない" do
    @user.password = @user.password_confirmation = "  "
    assert_not @user.valid?
  end

  test "passwordは最低8文字である" do
    @user.password = @user.password_confirmation = "a" * 7
    assert_not @user.valid?
  end

end
