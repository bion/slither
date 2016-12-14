class WebArchiveRecord < ActiveRecord::Base
  belongs_to :pull
  validates :pull, :url, :date, presence: true
end
