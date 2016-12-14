class AddMissingIndices < ActiveRecord::Migration[5.0]
  def change
    add_index :alexa_records, :pull_id
    add_index :facebook_records, :pull_id
    add_index :google_analytics_id_records, :pull_id
    add_index :stored_pull_errors, :pull_id
    add_index :web_archive_records, :pull_id
    add_index :whois_records, :pull_id
  end
end
