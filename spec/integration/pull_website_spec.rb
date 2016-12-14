require_relative '../../lib/pull_website'
require_relative '../../lib/pull_runner'

describe 'Pulling data for a website' do
  let!(:website) { create :website, url: 'zerohedge.com' }
  let!(:pull) { create :pull, website: website, url: 'http://zerohedge.com' }

  context 'successful pull' do
    before do
      allow(Open3).to receive(:capture3).with("whois #{website.url}") do
        [WHOIS_FIXTURE]
      end

      VCR.use_cassette('pull_website') do
        PullRunner.new(pull).run
      end
    end

    describe '#save!' do
      it 'saves a AlexaRecord with the correct data' do
        record = AlexaRecord.last

        expect(record.global_rank).to eql 1202
        expect(record.country_rank).to eql 279
      end
    end

    include_examples 'similar web adapter'
    include_examples 'whois record adapter'
    include_examples 'web archive record adapter'
    include_examples 'facebook record adapter'
  end

  context 'adapter has errors' do
    let(:invalid_pull_website_data) do
      invalid_data = VALID_PULL_WEBSITE_DATA.deep_dup
      invalid_data[:preloaded_data]["overview"]["TopCountryShares"][0][1] = nil
      invalid_data
    end

    let(:subject) { PullRunner.new(pull) }

    before do
      allow(subject).to receive(:pull_data) { invalid_pull_website_data }
      subject.run
    end

    it 'does not save invalid adapters' do
      expect(SimilarWeb.count).to eq 0
    end

    it 'saves errors for the pull' do
      error_message = JSON.parse(Pull.last.stored_pull_errors.first.error)
      expect(error_message).to eq \
        "model" => "TopCountryShare",
        "message" => ["Percent traffic can't be blank"],
        "adapter" => "Adapter::SimilarWebAdapter"
    end
  end
end
