require_relative './base'

class Adapter::FacebookRecordAdapter < Adapter::Base
  def self.domain_task?
    true
  end

  def self.page_task?
    true
  end

  def build_models
    [
      FacebookRecord.new(pull_data[:facebook].merge(pull: pull))
    ]
  end
end
