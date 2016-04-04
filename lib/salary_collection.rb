# Methods that return statistical information about a list of salaries
module SalaryCollection
  def count
    salaries.count
  end

  def average_annual_pay
    return 0 unless salaries.count > 0

    sum = salaries.inject(0) { |sum, sal| sum + sal.annual_pay }
    sum / salaries.count
  end

  def median_annual_pay
    count = salaries.count
    return 0 unless count > 0

    sorted = sorted_salaries(:annual_pay)

    if count % 2 == 1
      sorted[count / 2].annual_pay
    else
      (sorted[count / 2 - 1].annual_pay + sorted[count / 2].annual_pay) / 2
    end
  end

  def rank_of(salary)
    rank = 0
    sorted_salaries(:annual_pay, desc: true).each_with_index do |s, index|
      rank = index + 1 if s == salary
    end

    rank
  end
end
