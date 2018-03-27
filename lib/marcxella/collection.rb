module Marcxella
  class Collection
    def initialize(node)
      @node = node
    end
    
    def records
      @node.css('record').map{|r| Record.new(r)}
    end
  end
end
