class CreateGoogleAnalyticsIdRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :google_analytics_id_records do |t|
      t.integer :pull_id, null: false
      t.string :google_analytics_id, null: false
    end
  end
end
