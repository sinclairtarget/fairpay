module Util
  include ActionView::Helpers::NumberHelper

  def dollar(value, short: false)
    if value < 100
      number_to_currency(value)
    elsif short and value >= 1000
      number_to_currency(value / 1000, precision: 0) + "K"
    else
      number_to_currency(value, precision: 0)
    end
  end

  def self.fudge(value, range_divisor, salt)
    range_divisor = 1 if range_divisor < 1

    range = 2 * value * (0.15 / range_divisor)
    r = ((value % 11) + (salt % 11)) / 20.0

    min = value - (r * range)
    max = value + ((1 - r) * range)

    round_to = 1 - Math.log([value, 10].max, 10)
    [min.round(round_to), max.round(round_to)]
  end
end
