class GoogleAnalyticsIdRecord < ActiveRecord::Base
  belongs_to :pull
  validates :pull, :google_analytics_id, presence: true
end
