require_relative '../../../lib/sources/facebook'

describe Source::Facebook do
  let(:pull) { build :pull }
  subject { described_class.new pull }

  describe '#run' do
    it 'returns data for quantcast' do
      VCR.use_cassette 'facebook' do
        result = subject.run_safe[:facebook]

        expect(result[:shares]).to eql(25709)
        expect(result[:og_object_id]).to eql("10150174056578573")
        expect(result[:facebook_id]).to eql("http://zerohedge.com")
      end
    end
  end
end
