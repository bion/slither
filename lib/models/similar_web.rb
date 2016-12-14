class SimilarWeb < ActiveRecord::Base
  belongs_to :pull
  validates :pull, presence: true

  has_many :ad_networks, dependent: :destroy
  has_many :country_ranks, dependent: :destroy
  has_many :referrals, dependent: :destroy
  has_many :top_country_shares, dependent: :destroy
  has_many :weekly_traffic_numbers, dependent: :destroy
end
