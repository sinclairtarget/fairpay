class Salary < ActiveRecord::Base
  validates :title, presence: true
  validates :annual_pay, presence: true, 
                         numericality: { only_integer: true,
                                         greater_than_or_equal_to: 0 }
  validates :user_id, presence: true
  validates :group_id, presence: true
end
