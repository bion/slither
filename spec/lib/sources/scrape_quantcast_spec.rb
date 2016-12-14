require_relative '../../../lib/sources/scrape_quantcast'

describe Source::ScrapeQuantcast do
  let(:pull) { build :pull }
  subject { described_class.new pull }

  describe '#run' do
    it 'returns data for quantcast' do
      VCR.use_cassette 'quantcast' do
        result = subject.run
        expect(result).to eql(EXPECTED_QUANTCAST_DATA)
      end
    end
  end

  EXPECTED_QUANTCAST_DATA = {
    quantcast_data: {
      "name" => "zerohedge.com",
      "icon" => "//ak.quantcast.com/favico/zerohedge.com?default=false",
      "type" => "Site",
      "desc" => "zerohedge.com reaches over 11 million monthly people, of which 8.5 million &#x28;82&#x25;&#x29; are in the U.S.",
      "country" => { "code" => "US", "name" => "United States" },
      "metrics" => {
        "country_uniques" => 11122224,
        "global_uniques" => 13774748,
        "country_rank" => nil,
        "country_rank_link" => nil
       },
      "quantified" => true,
      "quantification_in_progress" => false,
      "managed_by_current_user" => false
    }
  }
end
