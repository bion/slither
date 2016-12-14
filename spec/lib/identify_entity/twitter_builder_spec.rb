require_relative '../../../lib/identify_entity/twitter_builder'

describe IdentifyEntity::TwitterBuilder do
  let(:uri) do
    URI.parse("https://twitter.com/Snowden/status/800080836326326272")
  end

  describe '.valid_identifier?' do
    it "should return true for a twitter URI" do
      expect(described_class.valid_identifier?(uri)).to eq(true)
    end
  end

  describe '#find_or_build_entity' do
    subject { described_class.new(uri) }

    it "should build an Entity" do
      entity = subject.find_or_build_entity

      expect(entity).to_not be_nil
      expect(entity.name).to eq('snowden')
      expect(entity.kind).to eq('twitter-user')
      expect(entity).to be_valid
    end
  end
end
