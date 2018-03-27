RSpec.describe Marcxella do
  it "has a version number" do
    expect(Marcxella::VERSION).not_to be nil
  end
end

RSpec.describe Marcxella::Document do
  it "can be created from a file handle" do
    f = File.open(XML_BUTLER, 'r')
    d = Marcxella::Document.new(f)
    expect(d).to be_a Marcxella::Document
    expect(d.document).to be_a Nokogiri::XML::Document
  end

  it "can be created from a Nokogiri::XML::Document" do
    f = Nokogiri::XML(XML_BUTLER)
    d = Marcxella::Document.new(f)
    expect(d).to be_a Marcxella::Document
  end

  it "returns the Nokogiri::XML::Document it was created from" do
    f = Nokogiri::XML(XML_BUTLER)
    d = Marcxella::Document.new(f)
    expect(d.document).to equal(f)
  end

  it "can be created from a string" do
    f = File.open(XML_BUTLER, 'r')
    d = Marcxella::Document.new(f.read)
    expect(d).to be_a Marcxella::Document
  end

  describe "#records" do
    before(:context) do
      @butler = Marcxella::Document.new(File.open(XML_BUTLER, 'r'))
    end

    it "returns records" do
      expect(@butler.records).to be_a Array
      expect(@butler.records.map{|r| r.class}.uniq).to eq [Marcxella::Record]
    end
  end
end

RSpec.describe Marcxella::Record do
  it "can be created from a Nokogiri::node" do
    doc = Nokogiri::XML(File.open(XML_BUTLER))
    node = doc.css('record').first
    expect(Marcxella::Record.new(node)).to be_a Marcxella::Record
  end
end
    
    
