require 'test_helper'

class SpotTest < ActiveSupport::TestCase

  def setup
    @user  = users(:one)
    @post = @user.posts.build(title: "PostTitle",
                              image_post: "",
                              place: "PostPlace"
    )
    @spot = @post.spots.build(place: "SpotPlace",
                               image_spot: "",
                               explaine: "SpotExplaine")
  end

  test "placeは空白でない" do
    @spot.place = "  "
    assert_not @spot.valid?
  end

  test "placeは最大20文字" do
    @spot.place = "a" * 21
    assert_not @spot.valid?
  end

  test "explaineは空白でない" do
    @spot.explaine = "  "
    assert_not @spot.valid?
  end

  test "explaineは最大300文字" do
    @spot.explaine = "a" * 301
    assert_not @spot.valid?
  end

end
