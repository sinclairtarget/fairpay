class AddHoursPerWeekToSalary < ActiveRecord::Migration
  def change
    change_table :salaries do |t|
      t.integer :hours_per_week
    end
  end
end
