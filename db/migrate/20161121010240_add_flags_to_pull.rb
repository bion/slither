class AddFlagsToPull < ActiveRecord::Migration[5.0]
  def change
    add_column :pulls, :url, :string
    add_column :pulls, :run_source_code_tasks, :boolean, default: true
    add_column :pulls, :run_external_service_tasks, :boolean, default: true
  end
end
