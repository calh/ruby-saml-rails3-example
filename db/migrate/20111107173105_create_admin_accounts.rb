class CreateAdminAccounts < ActiveRecord::Migration
  def change
    create_table :admin_accounts do |t|
      t.string :host
      t.integer :idle_timeout
      t.integer :session_timeout
      t.references :setting

      t.timestamps
    end
    add_index :admin_accounts, :setting_id
  end
end
