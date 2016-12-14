require_relative '../../../lib/sources/scrape_web_archive'

describe Source::ScrapeWebArchive do
  let(:pull) { build :pull }
  subject { described_class.new pull }

  describe '#run' do
    it 'returns data for similarweb' do
      VCR.use_cassette 'web_archive' do
        result = subject.run

        expect(result[:web_archive][:date]).to eql('Fri, 13 Feb 2009 10:34:31 GMT')
        expect(result[:web_archive][:url]).to eql('http://web.archive.org/web/20090213103431/http://www.zerohedge.com/')
      end
    end
  end
end
