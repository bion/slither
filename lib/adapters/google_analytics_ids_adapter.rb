require_relative './base'

class Adapter::GoogleAnalyticsIdsAdapter < Adapter::Base
  def self.page_task?
    true
  end

  protected

  def build_models
    pull_data[:google_analytics_ids].map do |ga_id|
      GoogleAnalyticsIdRecord.new(pull: pull, google_analytics_id: ga_id)
    end
  end
end
