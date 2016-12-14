require_relative '../../../lib/sources/scrape_alexa'

describe Source::ScrapeAlexa do
  let(:pull) { build :pull }
  subject { described_class.new pull }

  describe '#run' do
    it 'returns data for quantcast' do
      VCR.use_cassette 'alexa' do
        result = subject.run_safe
        expect(result[:global_rank]).to eql(1202)
        expect(result[:country_rank]).to eql(279)
      end
    end
  end
end
