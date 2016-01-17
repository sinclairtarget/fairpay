class Group < ActiveRecord::Base
  validates :name, presence: true
  has_many :salaries, dependent: :destroy
  has_many :users, through: :salaries
end
