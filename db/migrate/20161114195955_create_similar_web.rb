class CreateSimilarWeb < ActiveRecord::Migration[5.0]
  def change
    create_table :similar_webs do |t|
      t.integer :pull_id, null: false
      t.string :category
      t.boolean :is_verified
      t.string :icon_url
      t.string :redirect_url
      t.float :bounce_rate
      t.float :page_views
      t.integer :time_on_site_seconds
      t.string :total_last_month_visits
      t.float :total_relative_delta
      t.integer :last_engagement_year
      t.integer :last_engagement_month
      t.float :traffic_from_search
      t.float :traffic_from_social
      t.float :traffic_from_mail
      t.float :traffic_from_paid_referrals
      t.float :traffic_from_direct
      t.float :traffic_from_referrals
      t.float :traffic_from_app_store_internals
      t.timestamps
    end

    add_index :similar_webs, :pull_id

    create_table :weekly_traffic_numbers do |t|
      t.integer :similar_web_id, null: false
      t.integer :value, null: false
      t.date :week_of, null: false
    end

    add_index :weekly_traffic_numbers, :similar_web_id

    create_table :referrals do |t|
      t.integer :similar_web_id, null: false
      t.integer :kind, null: false
      t.string :url, null: false
      t.float :value, null: false
      t.float :delta, null: false
    end

    add_index :referrals, :similar_web_id

    create_table :ad_networks do |t|
      t.integer :similar_web_id, null: false
      t.string :name, null: false
      t.float :percent_served, null: false
    end

    add_index :ad_networks, :similar_web_id

    create_table :top_country_shares do |t|
      t.integer :similar_web_id, null: false
      t.integer :country_number, null: false
      t.float :percent_traffic, null: false
    end

    add_index :top_country_shares, :similar_web_id
    add_index :top_country_shares, :country_number

    create_table :country_ranks do |t|
      t.integer :similar_web_id, null: false
      t.integer :country_number, null: false
      t.integer :rank, null: false
      t.integer :rank_delta, null: false
    end

    add_index :country_ranks, :similar_web_id
  end
end
