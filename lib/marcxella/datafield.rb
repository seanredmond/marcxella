module Marcxella
  class DataField
    attr_reader :tag, :ind1, :ind2, :subfields
    def initialize(node)
      @tag = node['tag']
      @ind1 = node['ind1']
      @ind2 = node['ind2']
      @subfields = node.css('subfield').map{|s| SubField.new(s)}
    end
  end
end
