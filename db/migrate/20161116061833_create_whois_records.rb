class CreateWhoisRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :whois_records do |t|
      t.integer :pull_id, null: false
      t.string :registrant_name, null: false
    end
  end
end
