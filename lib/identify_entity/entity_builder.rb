require 'mechanize'
require_relative '../agent'

class IdentifyEntity
  class EntityBuilder
    include Agent

    attr_reader :uri

    def initialize(uri)
      @uri = uri
    end

    def find_or_build_entity
      raise NotImplementedError
    end

    def self.builders
      @builders ||= []
    end

    def self.inherited(other)
      builders << other
    end

    def self.valid_identifier?(uri)
      valid_domains.include?(uri.host)
    end

    def self.valid_domains
      []
    end

    private

    def agent
      @agent ||= Mechanize.new
    end

    def entity
      @entity ||= Entity.find_or_initialize_by(url: uri.to_s)
    end
  end
end

Dir.glob(File.dirname(__FILE__) + "/**/*.rb").each do |f|
  require f
end
