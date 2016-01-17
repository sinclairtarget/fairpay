require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  test "group must have a name" do
    group = Group.new
    assert group.invalid?
    assert_not_nil group.errors[:name]
  end
end
