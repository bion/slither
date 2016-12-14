require_relative './base'

class Source::ScrapeGoogleAnalyticsId < Source::Base
  def run
    { google_analytics_ids: get_ids }
  end

  def self.page_task?
    true
  end

  private

  def get_ids
    get_page
      .content
      .scan(/UA-[0-9]{5,}-[0-9]{1,}/)
      .uniq
  end
end
