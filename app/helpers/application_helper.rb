require_relative "../../lib/util/util.rb"

module ApplicationHelper
  LANDING_URL = "http://paysymmetry.com".freeze
  MIN_GROUP_MEMBERS = 3

  def fudged_salary(salary, members)
    return [false, dollar(salary.annual_pay)] if members > MIN_GROUP_MEMBERS

    salt = salary.updated_at.to_i
    min, max = Util.fudge(salary.annual_pay, members, salt)
    [true, dollar(min, short: true) + " – " + dollar(max, short: true)]
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

  def titles_for_autocomplete(group)
    salaries_by_title = group.salaries_by_title

    titles_string = ""
    salaries_by_title.each do |title, salaries|
      titles_string << "#{title},#{salaries.count};"
    end

    titles_string
  end
end
