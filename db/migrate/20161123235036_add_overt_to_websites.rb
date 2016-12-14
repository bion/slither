class AddOvertToWebsites < ActiveRecord::Migration[5.0]
  def change
    add_column :websites, :overt, :boolean, default: false, null: false
  end
end
