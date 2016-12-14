require_relative '../../../lib/identify_entity/amazon_affiliate_builder'

describe IdentifyEntity::AmazonAffiliateBuilder do
  context 'uri is bare amazon link' do
    let(:amazon_uri) do
      URI.parse("https://www.amazon.com/gp/kindle/ku/sign-up?ie=UTF8&*Version*=1&*entries*=0&ref_=assoc_tag_ph_1454291293420&_encoding=UTF8&camp=1789&creative=9325&linkCode=pf4&tag=theevechr-20&linkId=31e6c8512e54768abecb9c2721f5cf4a")
    end

    describe '.valid_identifier?' do
      it "should return true for an amazon URI" do
        expect(described_class.valid_identifier?(amazon_uri)).to eq(true)
      end
    end

    describe '#find_or_build_entity' do
      subject { described_class.new(amazon_uri) }

      it "should build an Entity" do
        entity = subject.find_or_build_entity

        expect(entity).to_not be_nil
        expect(entity.name).to eq('theevechr-20')
        expect(entity.kind).to eq('amazon-affiliate')
        expect(entity).to be_valid
      end
    end
  end

  context 'uri is shortened' do
    let(:shortened_uri) { URI('http://amzn.to/22FS4qp') }

    describe '.valid_identifier?' do
      it "should return true for a shortened amazon URI" do
        expect(described_class.valid_identifier?(shortened_uri)).to eq(true)
      end
    end

    describe '#find_or_build_entity' do
      subject { described_class.new(shortened_uri) }

      it "should build an Entity" do
        VCR.use_cassette 'amazon_affiliate_builder' do
          entity = subject.find_or_build_entity

          expect(entity).to_not be_nil
          expect(entity.name).to eq('theeconomiccollapse-20')
          expect(entity.kind).to eq('amazon-affiliate')
          expect(entity).to be_valid
        end
      end
    end
  end
end
