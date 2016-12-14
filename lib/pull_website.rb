require_relative './pull_runner'
require_relative './crawl_domain'

class PullWebsite
  def self.run(*args)
    new(*args).run
  end

  attr_reader :website

  def initialize(website)
    @website = website
  end

  def run
    error_count = runners.map { |runner| error_count = runner.run }.sum
    CrawlDomain.run(website)
    error_count
  end

  private

  def runners
    @runners ||= pulls.map { |pull| PullRunner.new(pull) }
  end

  def pulls
    @pulls ||= [
      create_domain_pull,
      create_archive_org_pull
    ].compact
  end

  def create_domain_pull
    Pull.create(
      website: website,
      url: "http://#{website.url}",
      page: true,
      domain: true,
    )
  end

  def create_archive_org_pull
    uri = URI("http://web.archive.org/web/timemap/link/#{website.url}")

    url, date = Net::HTTP.get(uri)
      .match(/<(.+)>; rel=\"first memento\"; datetime=\"(.+)\",/)
      .captures

    time = Time.parse(date)

    Pull.create!(
      website: website,
      url: url,
      page: true,
      domain: false,
      created_at: time,
      updated_at: time
    )
  rescue
    nil
  end
end
