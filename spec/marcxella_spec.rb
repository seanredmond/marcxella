RSpec.describe Marcxella do
  it "has a version number" do
    expect(Marcxella::VERSION).not_to be nil
  end
end

RSpec.describe Marcxella::Record do
  it "can be created from a Nokogiri::node" do
    doc = Nokogiri::XML(File.open(XML_BUTLER))
    node = doc.css('record').first
    expect(Marcxella::Record.new(node)).to be_a Marcxella::Record
  end
end
    
    
