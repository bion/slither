class AssociateExternalLinksToPulls < ActiveRecord::Migration[5.0]
  def change
    remove_column :external_links, :referers
    remove_column :external_links, :referer_domains
    remove_column :external_links, :count

    add_column :external_links, :pull_id, :integer, null: false
    add_column :external_links, :entity_id, :integer
  end
end
