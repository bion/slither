require_relative './agent'
require_relative './identify_entity'
require_relative './normalized_uri_cache'
require_relative './util/unsafe_queue'

class CrawlDomain
  include Agent

  MAX_PAGES = ENV['SLITHER_CRAWL_DEPTH'] || 100

  attr_reader :domain,
    :local_page_cache,
    :pages_to_crawl,
    :website,
    :logfile

  def self.run(*args)
    new(*args).crawl_page
  end

  def initialize(website)
    @website = website
    @domain = URI("http://#{website.url}")
    @local_page_cache = NormalizedURICache.new
    @local_page_cache.add(@domain)
    @external_link_count = 0
    @pages_to_crawl = UnsafeQueue.new << @domain
    @logfile = File.open("log/#{website.url}.log", "a")
  end

  def crawl_page
    page_count = 0

    until finished?(page_count) do
      this_uri = pages_to_crawl.pop(true) rescue nil

      next unless valid_uri?(this_uri)
      next unless get_uri(this_uri)
      next unless valid_page?(agent.page)
      logfile.puts "crawling #{this_uri}, #{pages_to_crawl.length} to process, #{@external_link_count} external links"

      pull = process_page(agent.page, this_uri)

      get_page_links.each do |uri|
        if valid_uri?(uri) && external_link?(uri)
          ingest_external_uri(this_uri, uri, pull)
        else
          unless local_page_cache.seen?(uri)
            local_page_cache.add(uri)
            pages_to_crawl << uri
          end
        end
      end

      page_count += 1
    end

    logfile.puts "done crawling #{website.url}! crawled #{page_count}."
    logfile.close
  end

  private

  def finished?(page_count)
    pages_to_crawl.empty? || page_count == MAX_PAGES
  end

  def get_page_links
    agent.page.links.map do |link|
      link.resolved_uri rescue nil
    end.compact
  end

  def valid_uri?(uri)
    return false if uri.nil?
    return false unless uri.scheme&.starts_with? 'http'
    return false if uri.path =~ /\.(?:jpeg|jpg|png|gif|css|js)$/
    return true
  end

  def valid_page?(page)
    return false unless page.is_a? Mechanize::Page
    return false unless page.content_type.include? 'html'
    return true
  end

  def get_uri(uri)
    agent.get(uri)
    return true
  rescue
    return false
  end

  def external_link?(uri)
    current_host != canonical_domain(uri.host)
  end

  def current_host
    @current_host ||= canonical_domain(domain.host)
  end

  def canonical_domain(host)
    return host unless host.starts_with?('www.')

    host[4..-1]
  end

  def process_page(page, uri)
    pull = Pull.create!(
      website: website,
      url: uri,
      page: true,
      domain: false
    )

    PullRunner.new(pull, page)

    pull
  end

  def ingest_external_uri(this_uri, uri, pull)
    link = ExternalLink.new(url: uri.to_s, domain: uri.host, pull: pull)

    link.entity = IdentifyEntity.run(uri)

    link.save!

    @external_link_count += 1
  end
end
