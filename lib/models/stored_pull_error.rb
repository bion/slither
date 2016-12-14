require 'json'

class StoredPullError < ActiveRecord::Base
  belongs_to :pull
  validates :pull, :location, :error, presence: true

  def error=(val)
    super JSON.generate(val)
  end
end
