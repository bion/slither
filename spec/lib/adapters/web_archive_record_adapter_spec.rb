require_relative '../../../lib/adapters/web_archive_record_adapter'

describe Adapter::WebArchiveRecordAdapter do
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

    include_examples 'web archive record adapter'
  end

  context 'invalid data' do
    let(:pull_data) do
      invalid_data = VALID_PULL_WEBSITE_DATA.deep_dup
      invalid_data[:web_archive] = nil
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
        expected_errors = [{ "Exception" => "Exception thrown in Adapter::WebArchiveRecordAdapter for pull with id 1" }]

        expect(subject.errors).to eql(expected_errors)
      end
    end
  end
end
