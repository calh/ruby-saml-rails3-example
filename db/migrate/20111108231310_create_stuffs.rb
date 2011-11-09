class CreateStuffs < ActiveRecord::Migration
  def change
    create_table :stuffs do |t|

      t.timestamps
    end
  end
end
