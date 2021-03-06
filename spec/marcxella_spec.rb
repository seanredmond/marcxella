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

    it "returns records from inside collections" do
      lengle = Marcxella::Document.new(File.open(XML_LENGLE, 'r'))
      expect(lengle.records.map{|r| r.class}.uniq).to eq [Marcxella::Record]
    end
  end

  describe "#collections" do
    before(:context) do
      @butler = Marcxella::Document.new(File.open(XML_BUTLER, 'r'))
    end

    it "returns collections" do
      lengle = Marcxella::Document.new(File.open(XML_LENGLE, 'r'))
      expect(lengle.collections.map{|r| r.class}.uniq).
        to eq [Marcxella::Collection]
    end

    it "is an empty Array if there are no collections" do
      expect(@butler.collections).to be_a Array
      expect(@butler.collections).to be_empty
    end
  end

  
end

RSpec.describe Marcxella::Collection do
  describe "instantiation" do
    it "can be created from a Nokogiri::node" do
      doc = Nokogiri::XML(File.open(XML_LENGLE))
      node = doc.css('collection').first
      expect(Marcxella::Collection.new(node)).to be_a Marcxella::Collection
    end
  end

  describe "methods" do
    before(:context) do
      @lengle = Marcxella::Document.new(File.open(XML_LENGLE, 'r'))
    end

    describe "#records" do
      it "returns records" do
        expect(@lengle.records).to be_a Array
        expect(@lengle.records.count).to eq 1
        expect(@lengle.records.map{|r| r.class}.uniq).to eq [Marcxella::Record]
      end
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
      @wrinkle = Marcxella::Document.new(File.open(XML_LENGLE, 'r')).
                   records.first
      @quilt = Marcxella::Document.new(File.open(XML_QUILT)).
                 records.first
    end

    describe "#field" do
      it "has a leader" do
        expect(@kindred.leader).to eq '00000cam a2200000Mi 4500'
      end
      
      it "returns a field by tag (as a string)" do
        f = @kindred.field("245")
        expect(f).to be_a Array
        expect(f.map{|r| r.class}.uniq).to eq [Marcxella::DataField]
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

    describe "#subfield" do
      it "returns the specified subfields" do
        s = @kindred.subfield("650", "a")
        expect(s).to be_a Array
        expect(s.count).to eq 2
        expect(s.map{|f| f.class}.uniq).to eq [Marcxella::SubField]
      end

      it "returns nothing from fields that don't have the subfield" do
        # There is one 651 field with an $x and one without
        s = @kindred.subfield("651", "x")
        expect(s).to be_a Array
        expect(s.count).to eq 1
      end

      it "returns an empty array if there are no matches" do
        s = @kindred.subfield("650", "9")
        expect(s).to be_a Array
        expect(s).to be_empty
      end
    end
    
    describe "#mainEntry" do
      it "returns a single main entry data field" do
        m = @kindred.mainEntry
        q = @quilt.mainEntry
        expect(m).to be_a Marcxella::DataField
        expect(m.tag).to eq "100"
        expect(q).to be_a Marcxella::DataField
        expect(q.tag).to eq "111"
      end
    end

    describe "#titleStatement" do
      it "returns the title statement" do
        expect(@kindred.titleStatement.value).
          to eq "Kindred /Octavia E. Butler."
      end
    end

    describe "#controlFields" do
      it "returns the control fields" do
        ctrl = @kindred.controlFields
        expect(ctrl).to be_a Array
        expect(ctrl.map{|c| c.class}.uniq).to eq [Marcxella::ControlField]
        expect(ctrl.count).to eq 2
        expect(ctrl.first.tag).to eq "001"
        expect(ctrl.last.tag).to eq "008"
      end
    end

    describe "#codes" do
      it "returns the code fields" do
        codes = @kindred.codes
        expect(codes).to be_a Array
        expect(codes.count).to eq 2
        expect(codes.first.tag).to eq "020"
      end
    end
    
    describe "#titles" do
      it "returns all the title fields" do
        @binti = Marcxella::Document.new(File.open(XML_OKORAFOR)).
                 records.first
        expect(@binti.titles).to be_a Array
        expect(@binti.titles.count).to eq 2
        expect(@binti.titles.first.tag).to eq "245"
        expect(@binti.titles.last.tag).to eq "246"
      end
    end

    describe "#edition" do
      it "returns all the edition fields" do
        edition = @wrinkle.edition
        expect(edition).to be_a Array
        expect(edition.count).to eq 1
        expect(edition[0].tag).to eq "260"
      end
    end

    describe "#description" do
      it "returns all the description fields" do
        description = @wrinkle.description
        expect(description).to be_a Array
        expect(description.count).to eq 1
        expect(description[0].tag).to eq "300"
      end
    end

    describe "#series" do
      it "returns all the series fields" do
        marner = Marcxella::Document.new(File.open(XML_ELIOT, 'r')).
                   records.first
        series = marner.series
        expect(series).to be_a Array
        expect(series.count).to eq 1
        expect(series[0].tag).to eq "490"
      end
    end

    describe "#notes" do
      it "returns all the notes fields" do
        notes = @quilt.notes
        expect(notes).to be_a Array
        expect(notes.count).to eq 3
        expect(notes[0].tag).to eq "500"
      end
    end

    describe "#notes" do
      it "returns all the subject fields" do
        subjects = @kindred.subjects
        expect(subjects).to be_a Array
        expect(subjects.count).to eq 4
        expect(subjects[0].tag).to eq "650"
      end
    end

    describe "#addedEntries" do
      it "returns all the added entryfields" do
        added = @quilt.addedEntries
        expect(added).to be_a Array
        expect(added.count).to eq 2
        expect(added[0].tag).to eq "700"
        expect(added[1].tag).to eq "710"
      end
    end

    describe "#linking" do
      it "returns all the notes fields" do
        russian = Marcxella::Document.new(File.open(XML_RUSSIAN)).
                  records.first
        links = russian.linking
        expect(links).to be_a Array
        expect(links.count).to eq 1
        expect(links[0].tag).to eq "776"
      end
    end

    describe "#seriesAdded" do
      it "returns all the series added entry fields" do
        xenophon = Marcxella::Document.new(File.open(XML_XENOPHON)).
                  records.first
        series = xenophon.seriesAdded
        expect(series).to be_a Array
        expect(series.count).to eq 1
        expect(series[0].tag).to eq "810"
      end
    end

    describe "#holdings" do
      it "returns all the holdings fields" do
        binti = Marcxella::Document.new(File.open(XML_OKORAFOR)).
                 records.first
        holdings = binti.holdings
        expect(holdings).to be_a Array
        expect(holdings.count).to eq 1
        expect(holdings[0].tag).to eq "880"
      end
    end

    describe "#lccn" do
      it "returns the LCCN" do
        expect(@quilt.lccn).to eq "   00010705 "
      end

      it "returns nil if there is no LCCN" do
        expect(@kindred.lccn).to be_nil
      end
    end

    describe "#isbns" do
      it "returns an array of ISBNs" do
        expect(@kindred.isbns).to be_a Array
        expect(@kindred.isbns).to eq ["9781472214812", "1472214811"]
      end
    end

    describe "#issns" do
      it "returns an array of ISSNs" do
        fissures = Marcxella::Document.new(File.open(XML_FISSURES)).
                     records.first
        expect(fissures.issns).to be_a Array
        expect(fissures.issns).to eq ["1572733691 (pbk.)"]
      end

      it "is an empty array of there are no ISSNs" do
        expect(@kindred.issns).to be_a Array
        expect(@kindred.issns).to be_empty
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

  describe "#subfields" do
    it "has no subfields" do
      expect(@c.subfields).to be_a Array
      expect(@c.subfields).to be_empty
    end
  end

  describe "#subfield" do
    it "has no subfields" do
      expect(@c.subfield("a")).to be_a Array
      expect(@c.subfield("a")).to be_empty
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

  describe "#subfield" do
    it "returns subfields by code" do
      s = @d.subfield("a")
      expect(s).to be_a Array
      expect(s.map{|c| c.class}.uniq).to eq [Marcxella::SubField]
      expect(s.first.value).to eq "Kindred /"
    end
  end
  
  describe "#to_s" do
    it "can be turned into a string" do
      expect(@d.to_s).to eq "245  10$aKindred /$cOctavia E. Butler."
    end

    it "substitutes hashes for blank indicators" do
      expect(@kindred.field("020").first.to_s).to eq "020  #\#$a9781472214812"
    end
  end

  describe "#value" do
    it "returns the value" do
      expect(@d.value).to eq "Kindred /Octavia E. Butler."
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
