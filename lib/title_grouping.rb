require_relative "salary_collection.rb"

# Represents a collection of salaries with the same title.
class TitleGrouping
  include SalaryCollection

  def initialize(salaries)
    raise ArgumentError, "Non-matching titles!" if salaries.any? do |salary|
      salary.title != salaries.first.title
    end

    @salaries = salaries
  end

  def salaries
    @salaries
  end

  protected
  def sorted_salaries(key, desc = false)
    if desc
      @salaries.sort(&key).reverse!
    else
      @salaries.sort(&key)
    end
  end
end
