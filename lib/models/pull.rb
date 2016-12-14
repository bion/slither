class Pull < ActiveRecord::Base
  belongs_to :website
  validates :website, presence: true

  has_many :stored_pull_errors
  has_many :external_links

  has_one :alexa_record
  has_one :google_analytics_id_record
  has_one :similar_web
  has_one :web_archive_record
  has_one :whois_record
  has_one :facebook_record
end
