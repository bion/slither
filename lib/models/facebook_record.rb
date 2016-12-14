class FacebookRecord < ActiveRecord::Base
  belongs_to :pull
  validates :pull, :shares, :og_object_id, :facebook_id, presence: true
end
