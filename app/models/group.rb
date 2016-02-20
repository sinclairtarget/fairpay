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
end
