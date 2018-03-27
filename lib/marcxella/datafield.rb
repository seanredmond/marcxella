module Marcxella
  class DataField
    def initialize(node)
      @tag = node['tag']
      @ind1 = node['ind1']
      @ind2 = node['ind2']
    end
  end
end
