class CreateFacebookRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :facebook_records do |t|
      t.integer :pull_id, null: false
      t.integer :shares, null: false
      t.string :og_object_id, null: false
      t.string :facebook_id, null: false
    end
  end
end
