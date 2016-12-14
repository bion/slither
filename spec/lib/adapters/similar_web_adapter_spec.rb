require_relative '../../../lib/adapters/similar_web_adapter'

describe Adapter::SimilarWebAdapter do
  let!(:pull) { create :pull }

  context 'valid data' do
    let(:pull_data) { VALID_PULL_WEBSITE_DATA }
    subject { described_class.new(pull, pull_data) }

    describe '#valid?' do
      it 'returns true' do
        expect(subject.valid?).to be true
      end
    end

    describe '#errors' do
      it 'returns an empty array' do
        expect(subject.errors).to eq []
      end
    end

    describe '#save!' do
      before do
        subject.save!
      end

      include_examples 'similar web adapter'
    end
  end

  context 'invalid data' do
    context 'causes an exception' do
      subject { described_class.new(pull, nil) }

      describe '#valid?' do
        it 'returns false' do
          expect(subject.valid?).to be_falsey
        end
      end

      describe '#errors' do
        it 'returns the stringified exception in an array' do
          msg = "Exception thrown in Adapter::SimilarWebAdapter for pull with id #{pull.id}"
          expect(subject.errors).to eql([{ 'Exception' => msg}])
        end
      end
    end

    context 'individual models not valid' do
      let(:pull_data) do
        invalid_data = VALID_PULL_WEBSITE_DATA.deep_dup
        invalid_data[:preloaded_data]["overview"]["TopCountryShares"][0][1] = nil
        invalid_data
      end

      subject { described_class.new(pull, pull_data) }

      describe '#valid?' do
        it 'returns false' do
          expect(subject.valid?).to be false
        end
      end

      describe '#errors' do
        it "returns the invalid model's error messages" do
          expected_errors = [{
            model: "TopCountryShare",
            message: ["Percent traffic can't be blank"],
            adapter: "Adapter::SimilarWebAdapter"
          }]

          expect(subject.errors).to eql(expected_errors)
        end
      end
    end
  end
end
