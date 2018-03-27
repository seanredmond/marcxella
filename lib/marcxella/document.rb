module Marcxella
  class Document
    attr_reader :document
    def initialize(xml)
      @document = Nokogiri::XML(xml)
    end
  end
end
