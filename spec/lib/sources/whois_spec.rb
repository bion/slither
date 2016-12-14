require_relative '../../../lib/sources/whois'

describe Source::Whois do
  let(:pull) { build :pull }
  subject { described_class.new pull }

  describe '#run' do
    context 'success' do
      it 'returns data for whois' do
        allow(Open3).to receive(:capture3).with("whois zerohedge.com") do
          [WHOIS_FIXTURE]
        end

        expect(subject.run_safe).to eql(registrant_name: 'Georgi Hristozov')
      end
    end

    context 'error' do
      before do
        allow(Open3).to receive(:capture3).with("whois zerohedge.com") do
          raise StandardError.new("fake error")
        end
      end

      it 'saves a the errors and returns false' do
        result = subject.run_safe

        error_message = JSON.parse(pull.stored_pull_errors.first.error)['message']
        expect(error_message).to eq 'fake error'
        expect(result).to eq Hash.new
      end
    end
  end
end
