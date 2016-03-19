module Util
  def self.fudge(value, divisor)
    divisor = 1 if divisor < 1

    range = 2 * value * (0.15 / divisor)
    r = rand()

    min = value - (r * range)
    max = value + ((1 - r) * range)

    round_to = 1 - Math.log([value, 10].max, 10)
    [min.round(round_to), max.round(round_to)]
  end
end
