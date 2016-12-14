class AddAdsenseModel < ActiveRecord::Migration[5.0]
  def change
    create_table :adsense_id_records do |t|
      t.integer :pull_id, null: false
      t.string :adsense_id, null: false
    end

    add_index :adsense_id_records, :pull_id
  end
end
