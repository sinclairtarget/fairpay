class Group < ActiveRecord::Base
  validates :name, presence: true
  has_many :salaries, dependent: :destroy
  has_many :users, through: :salaries

  def titles
    Salary.where(group_id: id).distinct.pluck(:title)
  end

  def empty?
    users.count == 0
  end

  # Returns a hash of salary collection objects keyed by title.
  def salaries_by_title
    groupings = salaries.group_by(&:title)
    groupings.merge!(groupings) do |title, salaries|
      Statistics::TitleGrouping.new(salaries)
    end
  end

  def lowest_paying_title
    titles = titles_by_average_pay
    [titles.first["title"], titles.first["avg"].to_i]
  end

  def highest_paying_title
    titles = titles_by_average_pay
    [titles.last["title"], titles.last["avg"].to_i]
  end

  def statistics
    Statistics::SalaryCollection.new(self)
  end

  protected
  def sorted_salaries(key, desc = false)
    if desc
      salaries.order({ key => :desc })
    else
      salaries.order(key)
    end
  end

  def titles_by_average_pay
    titles = Group.connection.select_all <<-SQL
      SELECT title, AVG(annual_pay) AS avg
      FROM salaries
      WHERE group_id = #{id.to_i}
      GROUP BY title
      ORDER BY avg;
    SQL
  end
end
