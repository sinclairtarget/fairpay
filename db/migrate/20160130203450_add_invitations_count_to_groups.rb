class AddInvitationsCountToGroups < ActiveRecord::Migration
  def change
    change_table :groups do |t|
      t.integer :invitations_count, default: 0
    end
  end
end
