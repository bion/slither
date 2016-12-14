class ExternalLink < ActiveRecord::Base
  belongs_to :pull
  belongs_to :entity
  validates :pull, :url, :domain, :count, null: false
end
