require 'thread/future'

project_root = Pathname.new(File.absolute_path(__FILE__)).dirname.parent.to_s
Dir.glob("#{project_root}/lib/sources/*.rb").each { |f| require f }
Dir.glob("#{project_root}/lib/adapters/*.rb").each { |f| require f }

class PullRunner
  attr_reader :pull, :page

  def initialize(pull, page = nil)
    @pull = pull
    @page = page
  end

  def run
    valid_adapters, invalid_adapters = adapter_classes.map do |adapter|
      adapter.new(pull, pull_data)
    end.partition(&:valid?)

    ActiveRecord::Base.transaction do
      valid_adapters.each(&:save!)
      invalid_adapters.each(&:save_errors!)
    end

    pull.stored_pull_errors.count
  end

  # Run all sources concurrently and merge results.
  # Thread.future provided by https://github.com/meh/ruby-thread
  def pull_data
    @pull_data ||= source_classes
      .map { |source| Thread.future { source.run(pull, page) } }
      .reduce({}) { |result, source_future| result.merge(~source_future) }
  end

  private

  def source_classes
    Source::Base
      .source_classes
      .reject { |source| !pull.page? && source.page_task? }
      .reject { |source| !pull.domain? && source.domain_task? }
  end

  def adapter_classes
    Adapter::Base
      .adapter_classes
      .reject { |adapter| !pull.page? && adapter.page_task? }
      .reject { |adapter| !pull.domain? && adapter.domain_task? }
  end
end
