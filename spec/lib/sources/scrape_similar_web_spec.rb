require_relative '../../../lib/sources/scrape_similar_web'

describe Source::ScrapeSimilarWeb do
  let(:pull) { build :pull }
  subject { described_class.new pull }

  describe '#run' do
    it 'returns data for similarweb' do
      VCR.use_cassette 'similarweb' do
        result = subject.run
        expect(result[:preloaded_data]).to eql(EXPECTED_PRELOADED_DATA)
        expect(result[:geochart_data]).to eql(EXPECTED_GEOCHART_DATA)
      end
    end
  end
end

EXPECTED_GEOCHART_DATA = {"data" => [["Country", "Share"],
                                   ["United States", 65.9],
                                   ["Canada", 6.99], ["United Kingdom", 5.5],
                                   ["Australia", 2.41], ["Germany", 1.4]]}

EXPECTED_PRELOADED_DATA = {
                           "overview" =>
                             {"Date" => "2016-10-01T00:00:00",
                              "Country" => 840,
                              "AdNetworks" =>
                                {"Count" => 6,
                                 "Data" =>
                                   [["Outbrain", "", 0.9675402756703316, 0],
                                    ["sh.st", "", 0.006257962143314824, 0],
                                    ["AdSupply", "", 0.006257962143314824, 0],
                                    ["Google Display Network", "", 0.005541354476196526, 0],
                                    ["BuySellAds", "", 0.004831840291020076, 0],
                                    ["Other", "", 0.00957060527582216, 0]]},
                              "TrafficSources" =>
                                {"Search" => 0.10100315090235501,
                                 "Social" => 0.07693740372396736,
                                 "Mail" => 0.009169453072648421,
                                 "Paid Referrals" => 0.0005427112380564764,
                                 "Direct" => 0.4973312235774613,
                                 "Referrals" => 0.3150160574855114,
                                 "Appstore Internals" => 0.0},
                              "IsVerifiedData" => false,
                              "Icon" => "https://site-images.similarcdn.com/image?url=zerohedge.com&t=2&s=1&h=15264691543793368062",
                              "TopCountryShares" =>
                                [[840.0, 0.6589800443077805, 0.4400494385988768],
                                 [124.0, 0.06989892774001817, 0.29011656639576394],
                                 [826.0, 0.05498944442091769, 0.22707957840976906],
                                 [36.0, 0.024068949578729418, 0.1641894963946375],
                                 [276.0, 0.01395461573932383, 0.16939290745812738]],
                              "RedirectUrl" => "zerohedge.com",
                              "Category" => "News_and_Media",
                              "GlobalRank" => [1209, 0, 410, 0],
                              "CategoryRank" => [216, 0, 86, 0],
                              "Engagements" =>
                                {"BounceRate" => "54.24%",
                                 "PageViews" => "2.56",
                                 "TimeOnSite" => "00:04:25",
                                 "TotalLastMonthVisits" => "45.8M",
                                 "TotalRelativeChangeFormatted" => "33.69%",
                                 "TotalRelativeChange" => 0.3369254711329704,
                                 "LastEngagementYear" => 2016,
                                 "LastEngagementMonth" => 10,
                                 "WeeklyTrafficNumbers" =>
                                   {"2016-05-01" => 27170578, "2016-06-01" => 31290594, "2016-07-01" => 35734626, "2016-08-01" => 33988750, "2016-09-01" => 34275446, "2016-10-01" => 45823717}},
                              "CountryRanks" => {"840" => [436, 0, 170, 0]},
                              "Referrals" =>
                                {"destination" =>
                                 [{"Site" => "youtube.com", "Value" => 0.35841713410727866, "Change" => 0.36300746662238703},
                                  {"Site" => "twitter.com", "Value" => 0.038151151655171536, "Change" => 0.43204446713428596},
                                  {"Site" => "facebook.com", "Value" => 0.017604425761250167, "Change" => 0.9789257848080939},
                                  {"Site" => "addtoany.com", "Value" => 0.017376620806616786, "Change" => 1.0035236026831493},
                                  {"Site" => "wikileaks.org", "Value" => 0.016635418601842932, "Change" => 0.0}],
                               "referrals" =>
                                 [{"Site" => "drudgereport.com", "Value" => 0.6850426700828767, "Change" => 1.736073889354135},
                                  {"Site" => "rense.com", "Value" => 0.04595769418535687, "Change" => -0.10186116035715917},
                                  {"Site" => "stevequayle.com", "Value" => 0.012776068798118344, "Change" => 0.09544910664359726},
                                  {"Site" => "feedly.com", "Value" => 0.012344519816604319, "Change" => -0.3720811149443484},
                                  {"Site" => "finviz.com", "Value" => 0.012076397700924715, "Change" => -0.1271159537368878}]}}}
