require 'test_helper.rb'
require_relative '../../lib/util/util.rb'

class UtilTest < ActiveSupport::TestCase
  test "fudge returns a range including the original value" do
    value = 125000
    divisor = 2
    salt = 12345

    min, max = Util.fudge(value, divisor, salt)
    assert_operator value, :<=, max
    assert_operator value, :>=, min
  end
end
