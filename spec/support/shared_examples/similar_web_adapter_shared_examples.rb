RSpec.shared_examples 'similar web adapter' do
  it 'saves a SimilarWeb with correct attributes' do
    model = SimilarWeb.last

    expect(model.persisted?).to be true
    expect(model.category).to eql('News_and_Media')
    expect(model.is_verified?).to be false
    expect(model.icon_url).to eql "https://site-images.similarcdn.com/image?url=zerohedge.com&t=2&s=1&h=15264691543793368062"
    expect(model.redirect_url).to eql "zerohedge.com"
    expect(model.bounce_rate).to eql 0.5424
    expect(model.page_views).to eql 2.56
    expect(model.time_on_site_seconds).to eql 265
    expect(model.total_last_month_visits).to eql "45.8M"
    expect(model.total_relative_delta).to be_within(0.0001).of(0.3369)
    expect(model.last_engagement_year).to eql 2016
    expect(model.last_engagement_month).to eql 10
    expect(model.traffic_from_search).to be_within(0.0001).of(0.1010)
    expect(model.traffic_from_social).to be_within(0.0001).of(0.0769)
    expect(model.traffic_from_mail).to be_within(0.0001).of(0.0091)
    expect(model.traffic_from_paid_referrals).to be_within(0.0001).of(0.0005)
    expect(model.traffic_from_direct).to be_within(0.0001).of(0.4973)
    expect(model.traffic_from_referrals).to be_within(0.0001).of(0.3150)
    expect(model.traffic_from_app_store_internals).to eql 0.0
  end

  it 'saves AdNetwork models with correct attributes' do
    similar_web = SimilarWeb.last

    models = similar_web.ad_networks
    expect(models.size).to eql 6
    outbrain = models.where(name: "Outbrain").first
    expect(outbrain.persisted?).to be true
    expect(outbrain.percent_served).to be_within(0.0001).of(0.96754)
  end

  it 'saves CountryRank models with correct attributes' do
    similar_web = SimilarWeb.last

    model = similar_web.country_ranks.first
    expect(model.persisted?).to be true
    expect(model.country_number).to eql 840
    expect(model.rank).to eql 436
    expect(model.rank_delta).to eql 170
  end

  it 'saves Referral models with correct attributes' do
    similar_web = SimilarWeb.last

    youtube = similar_web.referrals
      .where(url: "youtube.com", kind: :destination).first
    rensedotcom = similar_web.referrals
      .where(url: "rense.com", kind: :referral).first

    expect(youtube.value).to be_within(0.0001).of(0.3584)
    expect(youtube.delta).to be_within(0.0001).of(0.3630)
    expect(rensedotcom.value).to be_within(0.0001).of(0.0459)
    expect(rensedotcom.delta).to be_within(0.0001).of(-0.1018)
  end

  it 'saves TopCountryShare models with correct attributes' do
    similar_web = SimilarWeb.last

    usa_share = similar_web.top_country_shares.where(country_number: 840).first
    expect(usa_share.percent_traffic).to be_within(0.0001).of(0.6589)
  end

  it 'saves WeeklyTrafficNumber models with correct attributes' do
    similar_web = SimilarWeb.last
    most_recent = similar_web.weekly_traffic_numbers.order(week_of: :desc).first

    expect(most_recent.week_of).to eq(Date.parse("2016-10-01"))
    expect(most_recent.value).to eq(45823717)
  end
end
