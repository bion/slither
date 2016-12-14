class CreateStoredPullErrors < ActiveRecord::Migration[5.0]
  def change
    create_table :stored_pull_errors do |t|
      t.integer :pull_id, null: false
      t.string :location
      t.text :error
      t.timestamps
    end
  end
end
