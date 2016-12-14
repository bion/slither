RSpec.shared_examples 'facebook record adapter' do
  it 'saves a FacebookRecord with the correct attributes' do
    model = FacebookRecord.last

    expect(model.shares).to eql(25709)
    expect(model.og_object_id).to eql("10150174056578573")
    expect(model.facebook_id).to eql("http://zerohedge.com")
  end
end
