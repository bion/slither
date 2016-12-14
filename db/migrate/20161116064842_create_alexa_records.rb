class CreateAlexaRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :alexa_records do |t|
      t.integer :pull_id, null: false
      t.integer :global_rank, null: false
      t.integer :country_rank, null: false
    end
  end
end
