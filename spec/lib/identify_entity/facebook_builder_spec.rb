require_relative '../../../lib/identify_entity/facebook_builder'

describe IdentifyEntity::FacebookBuilder do
  let(:facebook_uri) do
    URI.parse("http://www.facebook.com/10153955897869294")
  end

  describe '.valid_identifier?' do
    it "should return true for a facebook URI" do
      expect(described_class.valid_identifier?(facebook_uri)).to eq(true)
    end
  end

  describe '#find_or_build_entity' do
    subject { described_class.new(facebook_uri) }

    it "should ignore share links" do
      builder = described_class.new(
        URI.parse(
          "http://www.facebook.com/share.php?"\
            "u=http://www.therebel.media/these_weird_comments_show%E2%80%9D]"
        )
      )

      expect(builder.find_or_build_entity).to be_nil
    end

    it "should build an Entity" do
      VCR.use_cassette "facebook_entity" do
        entity = subject.find_or_build_entity

        expect(entity).to_not be_nil
        expect(entity.name).to eq('roy.baker.1675')
        expect(entity.kind).to eq('facebook-page')
        expect(entity).to be_valid
      end
    end
  end
end
