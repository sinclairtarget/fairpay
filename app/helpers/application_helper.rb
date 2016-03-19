require_relative "../../lib/util/util.rb"

module ApplicationHelper
  LANDING_URL = "http://paysymmetry.com".freeze
  MIN_GROUP_MEMBERS = 3

  def fudged_salary(salary, members)
    return number_to_currency(salary.annual_pay) if members > 3

    salt = salary.updated_at.to_i
    min, max = Util.fudge(salary.annual_pay, members, salt)
    number_to_currency(min) + " – " + number_to_currency(max)
  end
end
