require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "test",
                     email: "test@test.com",
                     password: "password",
                     password_confirmation: "password"
    )
    @other_user = User.new(name: "test",
                           email: "test2@test.com",
                           password: "password",
                           password_confirmation: "password"
    )
  end

  test "nameは最大30文字である" do
    @user.name = "a" * 31
    assert_not @user.valid?
  end

  test "nameは空白でない" do
    @user.name = "  "
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

  test "emailの大文字小文字区別" do
    mixed_case_mail = "iNValId@Test.Com"
    @user.email = mixed_case_mail
    @user.save
    assert_equal mixed_case_mail.downcase, @user.reload.email
  end

  test "passwordは空白でない" do
    @user.password = @user.password_confirmation = "  "
    assert_not @user.valid?
  end

  test "passwordは最低8文字である" do
    @user.password = @user.password_confirmation = "a" * 7
    assert_not @user.valid?
  end

  test "introductionは最大で180文字" do
    @user.introduction = "a"*181
    assert_not @user.valid?
  end

  test "digestがnilである場合は、認証されない" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "ユーザーが削除された場合、関連する記事も削除される" do
    @user.save
    @user.posts.create!(title: "postTest",
                       place: "postPlace",
                       image_post: "default.png",
                       overview:   "overview",
                       spots_attributes: [{place: "spot",
                                           image_spot: "spot.png",
                                           explaine: "text"}]
    )
    assert_difference 'Post.count', -1 do
      @user.destroy
    end
  end

  test "ユーザーが削除された場合、お気に入りも削除される" do
    @user.save
    @post = @user.posts.create!( title: "postTest",
                         place: "postPlace",
                         image_post: "default.png",
                         overview:   "overview",
                         spots_attributes: [{place: "spot",
                                             image_spot: "spot.png",
                                             explaine: "text"}]
    )
    @user.likes.create!(user_id: @user.id,
                        post_id: @post.id
    )
    assert_difference 'Like.count', -1 do
      @user.destroy
    end
  end

  test "ユーザーが削除された場合、フォローも削除される" do
    @user.save
    @other_user.save
    Relationship.create!(following_id: @user.id,
                         followed_id:  @other_user.id
    )
    assert_difference 'Relationship.count', -1 do
      @user.destroy
    end
  end

end
