class CreatePulls < ActiveRecord::Migration[5.0]
  def change
    create_table :pulls do |t|
      t.integer :website_id, null: false
      t.timestamps
    end

    add_index :pulls, :website_id
  end
end
