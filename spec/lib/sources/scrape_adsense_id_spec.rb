require_relative '../../../lib/sources/scrape_adsense_id'

describe Source::ScrapeAdsenseId do
  let(:website) { create :website, url: 'wearechange.org' }
  let(:pull) { build :pull, website: website, url: "http://wearechange.org" }
  subject { described_class.new pull }

  it "should be enabled" do
    expect(Source::Base.source_classes).to include(described_class)
  end

  describe '#run' do
    it 'returns unique adsense ids' do
      VCR.use_cassette 'adsense_id' do
        expect(subject.run_safe[:adsense_ids]).to eq(%w[
          ca-pub-0005403334618616
        ])
      end
    end
  end
end
