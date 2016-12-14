class Website < ActiveRecord::Base
  has_many :pulls
  validates :url, :pull_count, presence: true
end
