require_relative '../../../lib/identify_entity/youtube_builder'

describe IdentifyEntity::YoutubeBuilder do
  let(:youtube_uri) do
    URI.parse("https://www.youtube.com/user/animdude")
  end

  describe '.valid_identifier?' do
    it "should return true for a youtube URI" do
      expect(described_class.valid_identifier?(youtube_uri)).to eq(true)
    end
  end

  describe '#find_or_build_entity' do
    subject { described_class.new(youtube_uri) }

    it "should build an Entity" do
      entity = subject.find_or_build_entity

      expect(entity.name).to eq('animdude')
      expect(entity.kind).to eq('youtube-user')
      expect(entity).to be_valid
    end
  end
end
