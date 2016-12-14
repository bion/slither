require_relative './base'

class Source::ScrapeAdsenseId < Source::Base
  def run
    { adsense_ids: get_ids }
  end

  def self.page_task?
    true
  end

  private

  def get_ids
    get_page
      .content
      .scan(/(?:ca-pub-|pub-)\d{16}/)
      .uniq
  end
end
