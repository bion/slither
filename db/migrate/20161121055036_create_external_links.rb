class CreateExternalLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :external_links do |t|
      t.string :url, null: false
      t.json :referers, default: []
      t.json :referer_domains, default: []
      t.string :domain, null: false
      t.integer :count, null: false, default: 1

      t.timestamps
    end

    add_index :external_links, :domain
  end
end
