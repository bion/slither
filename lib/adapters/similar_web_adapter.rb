require_relative './base'

class Adapter::SimilarWebAdapter < Adapter::Base
  def self.domain_task?
    true
  end

  protected

  def build_models
    [
      similar_web,
      ad_networks,
      country_ranks,
      incoming_referrals,
      outgoing_referrals,
      top_country_shares,
      weekly_traffic_numbers
    ].flatten.compact
  end

  private

  def data
    @data ||= pull_data[:preloaded_data]["overview"]
  end

  def similar_web
    @similar_web ||= SimilarWeb.new \
      pull: pull,
      category: data["Category"],
      is_verified: data["IsVerifiedData"],
      icon_url: data["Icon"],
      redirect_url: data["RedirectUrl"],
      bounce_rate: get_bounce_rate,
      page_views: data["Engagements"]["PageViews"]&.to_f,
      time_on_site_seconds: get_time_on_site,
      total_last_month_visits: data["Engagements"]["TotalLastMonthVisits"],
      total_relative_delta:  data["Engagements"]["TotalRelativeChange"],
      last_engagement_year: data["Engagements"]["LastEngagementYear"],
      last_engagement_month: data["Engagements"]["LastEngagementMonth"],
      traffic_from_search: data["TrafficSources"]["Search"],
      traffic_from_social: data["TrafficSources"]["Social"],
      traffic_from_mail: data["TrafficSources"]["Mail"],
      traffic_from_paid_referrals: data["TrafficSources"]["Paid Referrals"],
      traffic_from_direct: data["TrafficSources"]["Direct"],
      traffic_from_referrals: data["TrafficSources"]["Referrals"],
      traffic_from_app_store_internals: data["TrafficSources"]["Appstore Internals"]
  end

  def ad_networks
    data["AdNetworks"]["Data"]&.map do |name, _, percent_served, _|
      AdNetwork.new \
        similar_web: similar_web,
        name: name,
        percent_served: percent_served
    end
  end

  def country_ranks
    data["CountryRanks"]&.map do |country_number, rank_tuple|
      CountryRank.new \
        similar_web: similar_web,
        country_number: country_number.to_i,
        rank: rank_tuple[0],
        rank_delta: rank_tuple[2]
    end
  end

  def incoming_referrals
    data["Referrals"]["referrals"]&.map do |data_hash|
      Referral.new \
        kind: :referral,
        similar_web: similar_web,
        url: data_hash['Site'],
        value: data_hash['Value'],
        delta: data_hash['Change']
    end
  end

  def outgoing_referrals
    data["Referrals"]["destination"]&.map do |data_hash|
      Referral.new \
        kind: :destination,
        similar_web: similar_web,
        url: data_hash['Site'],
        value: data_hash['Value'],
        delta: data_hash['Change']
    end
  end

  def top_country_shares
    data["TopCountryShares"]&.map do |country_number, percent_traffic, _|
      TopCountryShare.new \
        similar_web: similar_web,
        country_number: country_number.to_i,
        percent_traffic: percent_traffic
    end
  end

  def weekly_traffic_numbers
    data["Engagements"]["WeeklyTrafficNumbers"]
      &.map do |date_string, value|
        WeeklyTrafficNumber.new \
          similar_web: similar_web,
          week_of: Date.parse(date_string),
          value: value
      end
  end

  def get_bounce_rate
    rate = data["Engagements"]["BounceRate"]
      &.gsub('%', '')
      &.to_f

    rate / 100.0 if rate
  end

  def get_time_on_site
    times = data["Engagements"]["TimeOnSite"]&.split(':')

    return unless times

    hours, minutes, seconds = times.map(&:to_i)
    (hours * 60 * 60) + (minutes * 60) + seconds
  end
end
