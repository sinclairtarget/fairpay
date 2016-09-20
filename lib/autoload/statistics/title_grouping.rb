module Statistics
  # A group of salaries with the same title
  class TitleGrouping 
    def initialize(salaries)
      if salaries
        raise ArgumentError, "Non-matching titles!" if salaries.any? do |salary|
          salary.title != salaries.first.title
        end
      end

      @salaries = salaries || []
    end

    def salaries
      @salaries
    end

    def count
      salaries.count
    end

    def can_show_average?
      salaries.count > 1
    end

    def statistics
     SalaryCollection.new(self)
    end
  end
end
