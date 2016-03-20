require_relative "../../lib/util/util.rb"

module ApplicationHelper
  LANDING_URL = "http://paysymmetry.com".freeze
  MIN_GROUP_MEMBERS = 3

  def fudged_salary(salary, members)
    return dollar(salary.annual_pay) if members > 3

    salt = salary.updated_at.to_i
    min, max = Util.fudge(salary.annual_pay, members, salt)
    dollar(min, short: true) + " – " + dollar(max, short: true)
  end

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
