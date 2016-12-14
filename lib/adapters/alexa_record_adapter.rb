require_relative './base'

class Adapter::AlexaRecordAdapter < Adapter::Base
  def self.domain_task?
    true
  end

  protected

  def build_models
    [
      AlexaRecord.new(
        pull: pull,
        global_rank: pull_data[:global_rank],
        country_rank: pull_data[:country_rank]
      )
    ]
  end
end
