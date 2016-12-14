require_relative '../../lib/identify_entity'

describe IdentifyEntity do
  describe '.run' do
    it "should return nil if it can't handle a URI" do
      bad_uri = URI.parse("http://ebaumsworld.com/hahaah.html")

      expect(IdentifyEntity.run(bad_uri)).to be_nil
    end

    it "should return an entity if it can handle the URI" do
      uri = URI.parse("https://www.youtube.com/user/animdude")

      entity = IdentifyEntity.run(uri)

      expect(entity).to be_persisted
    end
  end
end
