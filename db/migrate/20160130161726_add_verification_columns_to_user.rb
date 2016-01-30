class AddVerificationColumnsToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.boolean :verified, default: false
      t.string :verification_code
    end
  end
end
