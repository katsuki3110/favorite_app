require 'test_helper'

class CreatePostTest < ActiveSupport::TestCase

  def setup
    @user = users(:one)
    @post = @user.posts.build(title: "TestTitle",
                              image_post: "",
                              place: "TestPlace",
                              overview: "overview",
                              spots_attributes: [{place: "spot",
                                                  image_spot: "spot.png",
                                                  explaine: "text"}]
    )
  end

  test "titleは空白でない" do
    @post.title = "  "
    assert_not @post.valid?
  end

  test "titleは最大30文字" do
    @post.title = "a" * 31
    assert_not @post.valid?
  end

  test "placeは空白でない" do
    @post.place = "  "
    assert_not @post.valid?
  end

  test "placeは最大10文字" do
    @post.place = "a" * 11
    assert_not @post.valid?
  end

  test "overviewは空白でない" do
    @post.overview = "  "
    assert_not @post.valid?
  end

  test "overviewは最大100文字" do
    @post.overview = "a" * 101
    assert_not @post.valid?
  end

  test "postを削除した場合、spotも削除される" do
    @post.save
    assert_difference 'Spot.count', -1 do
      @post.destroy
    end
  end

  test "postを削除した場合、likesも削除される" do
    @user.save
    @post.save
    @user.likes.create!(user_id: @user.id,
                        post_id: @post.id
    )
    assert_difference 'Like.count', -1 do
      @post.destroy
    end
  end

end
