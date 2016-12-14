require_relative '../../../lib/adapters/facebook_record_adapter'

describe Adapter::FacebookRecordAdapter do
  let!(:pull) { create :pull }

  context 'valid data' do
    let(:pull_data) { VALID_PULL_WEBSITE_DATA }
    subject { described_class.new(pull, pull_data) }

    before do
      subject.save!
    end

    include_examples 'facebook record adapter'
  end
end
