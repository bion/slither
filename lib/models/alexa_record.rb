class AlexaRecord < ActiveRecord::Base
  belongs_to :pull
  validates :pull, :global_rank, :country_rank, presence: true
end
