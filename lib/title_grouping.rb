require_relative "salary_collection.rb"

# Represents a collection of salaries with the same title.
class TitleGrouping
  include SalaryCollection

  def initialize(salaries)
    raise ArgumentError, "Non-matching titles!" if salaries.any? do |salary|
      salary.title != salaries.first.title
    end

    @salaries = salaries
    @salaries = sorted_salaries(:annual_pay, desc: true)
  end

  def salaries
    @salaries
  end

  def can_show_average?
    @salaries.count > 1
  end

  protected
  def sorted_salaries(key, desc = false)
    if desc
      @salaries = sorted_salaries(key).reverse
    else
      @salaries.sort { |a, b| a[key] <=> b[key] }
    end
  end
end
