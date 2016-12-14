require 'countries'

class CountryRank < ActiveRecord::Base
  belongs_to :similar_web
  validates :similar_web, :country_number, :rank, :rank_delta, presence: true

  def country_name
    ISO3166::Country.find_all_by(:number, country_number)&.values&.first['name']
  end
end
