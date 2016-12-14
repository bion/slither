require 'mechanize'
require_relative './identify_entity/entity_builder'

class IdentifyEntity
  attr_reader :uri

  def self.run(*args)
    new(*args).run
  end

  def initialize(uri)
    @uri = uri
  end

  def run
    return nil unless builder

    entity = builder.find_or_build_entity

    return nil unless entity

    entity.save!

    entity
  rescue
    nil
  end

  private

  def builder
    @builder ||= EntityBuilder
      .builders
      .detect { |builder| builder.valid_identifier?(uri) }
      &.new(uri)
  end
end
