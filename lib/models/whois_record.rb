class WhoisRecord < ActiveRecord::Base
  belongs_to :pull
  validates :pull, :registrant_name, presence: true
end
