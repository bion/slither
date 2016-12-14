class Entity < ActiveRecord::Base
  ENTITY_KINDS = %w[
    amazon-affiliate
    youtube-user
    facebook-page
    twitter-user
  ]

  validates :url, :kind, presence: true
  validates :kind, inclusion: ENTITY_KINDS

  has_many :external_links
end
