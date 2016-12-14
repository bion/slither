require 'json'
require_relative './base'

class Source::ScrapeSimilarWeb < Source::Base
  def run
    agent.get("http://www.similarweb.com/website/#{domain}")

    {
      preloaded_data: get_preloaded_data(agent.page),
      geochart_data: get_geochart_data(agent.page)
    }
  end

  def self.domain_task?
    true
  end

  private

  def get_preloaded_data(page)
    JSON.parse(page.content[/Sw.preloadedData\ \=\ .+\;/, 0][19..-2])
  end

  def get_geochart_data(page)
    geochart_element = page.css('div[data-geochart]').first

    return unless geochart_element

    JSON.parse(geochart_element.attribute('data-geochart').value)
  end
end
