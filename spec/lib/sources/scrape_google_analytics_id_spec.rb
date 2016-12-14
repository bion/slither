require_relative '../../../lib/sources/scrape_google_analytics_id'

describe Source::ScrapeGoogleAnalyticsId do
  let(:website) { create :website, url: 'wearechange.org' }
  let(:pull) { build :pull, website: website, url: "http://wearechange.org" }
  subject { described_class.new pull }

  describe '#run' do
    it 'returns google analytics id' do
      VCR.use_cassette 'google_analytics_id' do
        expect(subject.run_safe[:google_analytics_ids]).to eq(["UA-30141356-1"])
      end
    end
  end
end
