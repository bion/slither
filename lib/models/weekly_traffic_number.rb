class WeeklyTrafficNumber < ActiveRecord::Base
  belongs_to :similar_web
  validates :similar_web, :week_of, :value, presence: true
end
