module Marcxella

  # Container for a MARC-XML document
  # @since 0.1.0
  # @attr_reader [Nokigiri::XML::Document] document wrapped Nokogiri document
  class Document
    attr_reader :document

    # Constructor for Document object
    # @param [Nokogiri::XML::Document, File, String] xml source
    def initialize(xml)
      if xml.is_a? Nokogiri::XML::Document
        @document = xml
      else
        @document = Nokogiri::XML(xml)
      end
    end

    # Record elements
    # @return [Array<Record>] array of record objects (possibly empty). If the
    #   document contains collection elements, returns record objects inside the
    #   collections
    def records
      @document.css('record').map{|r| Record.new(r)}
    end

    # Collection elements
    # @return [Array<Collection>] array of collection objects (possible empty).
    def collections
      @document.css('collection').map{|c| Collection.new(c)}
    end
    
  end
end
