class Salary < ActiveRecord::Base
  DEFAULT_HOURS_PER_WEEK = 40

  validates :title, presence: true
  validates :annual_pay, presence: true, 
                         numericality: { only_integer: true,
                                         greater_than_or_equal_to: 0 }
  validates :user_id, presence: true
  validates :group_id, presence: true
#  validate :force_immutable

  belongs_to :user
  belongs_to :group

  def initialize(**options)
    if options[:hourly_wage]
      hours_per_week = (options[:hours_per_week] || DEFAULT_HOURS_PER_WEEK)
      options[:annual_pay] = options[:hourly_wage] * hours_per_week * 52
      options.delete :hourly_wage
    end

    super
  end 

  after_initialize do |salary|
    salary.hours_per_week ||= DEFAULT_HOURS_PER_WEEK
  end

  def hourly_wage
    (annual_pay / 52.0) / hours_per_week.to_f
  end

  private
  def force_immutable
    if self.changed? and self.persisted?
      errors.add(:base, :immutable)
    end
  end
end
