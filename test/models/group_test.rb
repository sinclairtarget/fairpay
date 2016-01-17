require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  test "group must have a name" do
    group = Group.new
    assert group.invalid?
    assert group.errors[:name].any?
  end
end
