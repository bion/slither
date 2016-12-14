require_relative './base'

class Adapter::WhoisRecordAdapter < Adapter::Base
  def self.domain_task?
    true
  end

  protected

  def build_models
    [
      WhoisRecord.new(pull: pull, registrant_name: pull_data[:registrant_name])
    ]
  end
end
