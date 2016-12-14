RSpec.shared_examples 'web archive record adapter' do
  describe '#save!' do
    it 'saves a WebArchiveRecord with the id' do
      model = WebArchiveRecord.last
      expect(model.date.to_s).to eq "2009-02-13 10:34:31 UTC"
      expect(model.url).to eq "http://web.archive.org/web/20090213103431/http://www.zerohedge.com/"
    end
  end
end
