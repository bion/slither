class RenamePullFlags < ActiveRecord::Migration[5.0]
  def change
    rename_column :pulls, :run_source_code_tasks, :page
    rename_column :pulls, :run_external_service_tasks, :domain
  end
end
