require_relative '../agent'

module Source
  class Base
    include Agent

    class << self
      def source_classes
        @source_classes ||= []
      end

      def inherited(klass)
        source_classes << klass
      end

      def run(*args)
        new(*args).run_safe
      end

      def page_task?
        false
      end

      def domain_task?
        false
      end
    end

    attr_reader :pull, :domain, :page

    def initialize(pull, page = nil)
      @pull = pull
      @page = page
      @domain = pull.website.url
    end

    def url
      pull.url
    end

    def run
      raise NotImplementedError
    end

    def run_safe
      run
    rescue StandardError => error
      StoredPullError.create \
        pull: pull,
        location: self.class,
        error: { message: error.message, backtrace: error.backtrace }

      {}
    end

    def get_page
      page || agent.get(url)
    end
  end
end
