RSpec.shared_examples 'whois record adapter' do
  describe '#save!' do
    it 'saves a WhoisRecord with the correct data' do
      record = WhoisRecord.last

      expect(record.registrant_name).to eql "Georgi Hristozov"
    end
  end
end
