require_relative './base'

class Adapter::WebArchiveRecordAdapter < Adapter::Base
  def self.domain_task?
    true
  end

  protected

  def build_models
    entry = pull_data[:web_archive]

    [
      WebArchiveRecord.new(
        pull: pull,
        url: entry[:url],
        date: DateTime.parse(entry[:date])
      )
    ]
  end
end
