require 'json'
require_relative './base'

class Source::ScrapeQuantcast < Source::Base
  def run
    agent.get("http://www.quantcast.com/#{domain}?qcLocale=en_US")

    data_element = agent.page.css('script[key="profileSummary"]')
      &.first&.children&.first

    return nil unless data_element

    { quantcast_data: JSON.parse(data_element.content) }
  end

  def self.domain_task?
    true
  end
end
