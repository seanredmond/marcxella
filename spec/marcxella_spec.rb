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
  describe "instantiation" do
    it "can be created from a Nokogiri::node" do
      doc = Nokogiri::XML(File.open(XML_BUTLER))
      node = doc.css('record').first
      expect(Marcxella::Record.new(node)).to be_a Marcxella::Record
    end
  end

  describe "methods" do
    before(:context) do 
      @butler = Marcxella::Document.new(File.open(XML_BUTLER, 'r'))
      @kindred = @butler.records.first
    end

    describe "#field" do
      it "returns a field by tag (as a string)" do
        f = @kindred.field("245")
        expect(f).to be_a Array
        expect(f.map{|r| r.class}.uniq).to eq [Marcxella::DataField]
      end

      it "returns a field by tag (as a number)" do
        expect(@kindred.field(245).first).to be_a Marcxella::DataField
        expect(@kindred.field(001).first).to be_a Marcxella::ControlField
      end
      
      it "returns control fields and data fields" do
        expect(@kindred.field("245").first).to be_a Marcxella::DataField
        expect(@kindred.field("001").first).to be_a Marcxella::ControlField
      end
    end

    describe "#fields" do
      it "returns an Array" do
        expect(@kindred.fields).to be_a Array
      end

      it "returns an Array of ControlField and DataField objects" do
        field_types = @kindred.fields.map{|f| f.class}.uniq
        expect(field_types.count).to eq 2
        expect(field_types).to include (Marcxella::ControlField)
        expect(field_types).to include (Marcxella::DataField)
      end
    end
  end 
end

RSpec.describe Marcxella::ControlField do
  before(:context) do
    @butler = Marcxella::Document.new(File.open(XML_BUTLER, 'r'))
    @kindred = @butler.records.first
    @c = @kindred.field("001").first
  end

  it "has a tag" do
    expect(@c.tag).to eq "001"
  end

  it "has a value" do
    expect(@c.value).to eq "1027474578"
  end

  describe "#to_s" do
    it "can be turned into a string" do
      expect(@c.to_s).to eq "001    1027474578"
    end
  end
end
    
RSpec.describe Marcxella::DataField do
  before(:context) do
    @butler = Marcxella::Document.new(File.open(XML_BUTLER, 'r'))
    @kindred = @butler.records.first
    @d = @kindred.field("245").first
  end

  it "has a tag" do
    expect(@d.tag).to eq "245"
  end

  it "has two indicators" do
    expect(@d.ind1).to eq "1"
    expect(@d.ind2).to eq "0"
  end

  it "has subfields" do
    expect(@d.subfields).to be_a Array
    expect(@d.subfields.count).to eq 2
    expect(@d.subfields.map{|r| r.class}.uniq).to eq [Marcxella::SubField]
  end

  describe "#to_s" do
    it "can be turned into a string" do
      expect(@d.to_s).to eq "245  10$aKindred /$cOctavia E. Butler."
    end

    it "substitutes hashes for blank indicators" do
      expect(@kindred.field("020").first.to_s).to eq "020  #\#$a9781472214812"
    end
  end
end


RSpec.describe Marcxella::SubField do
  before(:context) do
    @butler = Marcxella::Document.new(File.open(XML_BUTLER, 'r'))
    @kindred = @butler.records.first
    @d = @kindred.field("245").first
    @s = @d.subfields.first
  end

  it "has a code" do
    expect(@s.code).to eq 'a'
  end

  it "has a value" do
    expect(@s.value).to eq 'Kindred /'
  end

  describe "#to_s" do
    it "can be turned into a string" do
      expect(@s.to_s).to eq '$aKindred /'
    end
  end
end
