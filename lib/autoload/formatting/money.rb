module Formatting
  module Money
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
  end
end
