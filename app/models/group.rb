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

  def average_annual_pay(title: nil)
    culled_list = salaries_with_title(title)
    return 0 unless culled_list.count > 0

    sum = culled_list.inject(0) { |sum, sal| sum + sal.annual_pay }
    sum / culled_list.count
  end

  def median_annual_pay(title: nil)
    culled_list = salaries_with_title(title).map { |sal| sal.annual_pay }
                                            .sort
    count = culled_list.count
    return 0 unless count > 0
    
    if count % 2 == 1
      culled_list[count / 2]
    else
      (culled_list[count / 2 - 1] + culled_list[count / 2]) / 2
    end
  end

  def title_count(title)
    salaries_with_title(title).count
  end

  def rank_of(salary)
    all = salaries_with_title(salary.title).order(:annual_pay)

    rank = 0
    all.each_with_index do |s, index|
      rank = index + 1 if s == salary
    end

    rank
  end

  protected
  def salaries_with_title(title = nil)
    if title
      salaries.where(title: title)
    else
      salaries
    end
  end
end
