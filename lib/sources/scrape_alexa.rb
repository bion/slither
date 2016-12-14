require_relative './base'

class Source::ScrapeAlexa < Source::Base
  def run
    agent.get("http://www.alexa.com/siteinfo/#{domain}")

    {
      global_rank: get_global_rank,
      country_rank: get_country_rank
    }
  end

  def self.domain_task?
    true
  end

  private

  def get_global_rank
    # 'global' is mispelled 'globle' in the page source
    get_rank('globleRank')
  end

  def get_country_rank
    get_rank('countryRank')
  end

  def get_rank(scope)
    agent.page.css("span.#{scope} .metrics-data")
      .first&.children&.last&.text&.strip&.gsub(',', '')&.to_i
  end
end
