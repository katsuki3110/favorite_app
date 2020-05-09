require 'test_helper'

class LikeTest < ActiveSupport::TestCase

  def setup
    @user = users(:one)
    @post = @user.posts.create!(title: "TestTitle",
                                image_post: "",
                                place: "TestPlace",
                                overview: "overview"
            )
    @like = @user.likes.create!(user_id: @user.id,
                                post_id: @post.id
            )
  end

  test "user_idは空白でない" do
    @like.user_id = ""
    assert_not @like.valid?
  end

  test "post_idは空白でない" do
    @like.post_id = ""
    assert_not @like.valid?
  end

end
