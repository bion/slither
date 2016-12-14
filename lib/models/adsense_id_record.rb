class AdsenseIdRecord < ActiveRecord::Base
  belongs_to :pull

  validates :pull, :adsense_id, presence: true
end
