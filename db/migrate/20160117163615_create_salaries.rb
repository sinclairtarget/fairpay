class CreateSalaries < ActiveRecord::Migration
  def change
    create_table :salaries do |t|
      t.integer :user_id
      t.integer :group_id
      t.string :title
      t.integer :annual_pay
      t.timestamps null: false
    end

    add_foreign_key :salaries, :users
    add_foreign_key :salaries, :groups
  end
end
