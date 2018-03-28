module Marcxella
  class DataField
    attr_reader :tag, :ind1, :ind2, :subfields
    def initialize(node)
      @tag = node['tag']
      @ind1 = node['ind1']
      @ind2 = node['ind2']
      @subfields = node.css('subfield').map{|s| SubField.new(s)}
    end

    def display
      @subfields.map{|s| s.value}.join('')
    end
    
    def to_s
      "%s  %s%s%s" % [@tag, ind_to_s(@ind1), ind_to_s(@ind2), @subfields.join('')]
    end

    def subfield(code)
      @subfields.select{|s| s.code == code }
    end
    
    def ind_to_s(i)
      if i == ' '
        return '#'
      end
      
      return i
    end
  end
end
