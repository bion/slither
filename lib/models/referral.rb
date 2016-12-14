class Referral < ActiveRecord::Base
  belongs_to :similar_web
  enum kind: { destination: 0, referral: 1 }
  validates :similar_web, :url, :value, :delta, :kind, presence: true
end
