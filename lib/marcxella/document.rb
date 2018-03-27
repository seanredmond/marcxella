module Marcxella
  class Document
    attr_reader :document
    def initialize(xml)
      if xml.is_a? Nokogiri::XML::Document
        @document = xml
      else
        @document = Nokogiri::XML(xml)
      end
    end

    def records
      @document.css('record').map{|r| Record.new(r)}
    end

    def collections
      @document.css('collection').map{|c| Collection.new(c)}
    end
    
  end
end
