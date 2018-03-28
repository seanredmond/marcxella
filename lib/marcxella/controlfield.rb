module Marcxella
  class ControlField
    attr_reader :tag, :value
    def initialize(node)
      @tag = node['tag']
      @value = node.text
    end
    
    def to_s
      "%s    %s" % [@tag, @value]
    end

    def display
      @value
    end
    
  end
end
