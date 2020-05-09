require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

  def setup
    @relationship = Relationship.new(following_id: users(:one).id,
                                     followed_id:  users(:two).id)
  end

  test "following_idは空白でない" do
    @relationship.following_id = nil
    assert_not @relationship.valid?
  end

  test "followed_idは空白でない" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end

end
