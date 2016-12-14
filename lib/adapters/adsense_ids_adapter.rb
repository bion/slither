require_relative './base'

class Adapter::AdsenseIdsAdapter < Adapter::Base
  def self.page_task?
    true
  end

  protected

  def build_models
    pull_data[:adsense_ids].map do |adsense_id|
      AdsenseIdRecord.new(pull: pull, adsense_id: adsense_id)
    end
  end
end
