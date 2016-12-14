class AddPullCountToWebsites < ActiveRecord::Migration[5.0]
  def change
    add_column :websites, :pull_count, :integer, default: 0, null: false
  end
end
