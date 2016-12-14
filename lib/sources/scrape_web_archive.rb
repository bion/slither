require 'net/http'
require_relative './base'

class Source::ScrapeWebArchive < Source::Base
  def run
    uri = URI("http://web.archive.org/web/timemap/link/#{domain}")

    url, date = Net::HTTP.get(uri)
      .match(/<(.+)>; rel=\"first memento\"; datetime=\"(.+)\",/)
      .captures

    {
      web_archive: {
        url: url,
        date: date
      }
    }
  end

  def self.domain_task?
    true
  end
end
