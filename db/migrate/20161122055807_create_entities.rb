class CreateEntities < ActiveRecord::Migration[5.0]
  def change
    create_table :entities do |t|
      t.string :url, null: false
      t.string :kind, null: false
      t.string :name
    end

    add_index :entities, :url
  end
end
