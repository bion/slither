class CreateWebArchiveRecord < ActiveRecord::Migration[5.0]
  def change
    create_table :web_archive_records do |t|
      t.integer :pull_id, null: false
      t.string :url, null: false
      t.datetime :date
    end
  end
end
