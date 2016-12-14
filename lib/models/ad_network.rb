class AdNetwork < ActiveRecord::Base
  belongs_to :similar_web
  validates :similar_web, :name, :percent_served, presence: true
end
