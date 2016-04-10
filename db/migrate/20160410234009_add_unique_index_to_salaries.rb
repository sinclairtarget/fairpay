class AddUniqueIndexToSalaries < ActiveRecord::Migration
  def change
    # no user can have two salaries in the same group
    add_index :salaries, [:group_id, :user_id], unique: true
  end
end
