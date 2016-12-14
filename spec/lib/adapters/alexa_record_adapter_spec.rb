require_relative '../../../lib/adapters/alexa_record_adapter'

describe Adapter::AlexaRecordAdapter do
  let!(:pull) { create :pull }

  context 'valid data' do
    let(:pull_data) { VALID_PULL_WEBSITE_DATA }
    subject { described_class.new(pull, pull_data) }

    before do
      subject.save!
    end

    describe '#valid?' do
      it 'returns true' do
        expect(subject.valid?).to be true
      end
    end

    describe '#errors' do
      it 'returns an empty array' do
        expect(subject.errors).to eql []
      end
    end


    describe '#save!' do
      it 'saves a AlexaRecord with the correct data' do
        record = AlexaRecord.last

        expect(record.global_rank).to eql 1248
        expect(record.country_rank).to eql 282
      end
    end
  end

  context 'invalid data' do
    let(:pull_data) do
      invalid_data = VALID_PULL_WEBSITE_DATA.deep_dup
      invalid_data[:global_rank] = nil
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
                            model: "AlexaRecord",
                            message: ["Global rank can't be blank"],
                            adapter: "Adapter::AlexaRecordAdapter"
                           }]

        expect(subject.errors).to eql(expected_errors)
      end
    end
  end
end
