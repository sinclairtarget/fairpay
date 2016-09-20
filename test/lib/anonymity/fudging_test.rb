require 'test_helper.rb'

class FudgingTest < ActiveSupport::TestCase
  include Anonymity::Fudging

  test "fudge returns a range including the original value" do
    value = 125000
    divisor = 2
    salt = 12345

    min, max = fudge(value, divisor, salt)
    assert_operator value, :<=, max
    assert_operator value, :>=, min
  end
end
