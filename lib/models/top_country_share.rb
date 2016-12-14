class TopCountryShare < ActiveRecord::Base
  belongs_to :similar_web
  validates :similar_web, :country_number, :percent_traffic, presence: true
end
