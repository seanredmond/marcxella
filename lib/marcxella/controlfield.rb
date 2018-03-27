module Marcxella
  class ControlField
    def initialize(node)
      @tag = node['tag']
      @value = node.text
    end
    
    def to_s
      "%s    %s" % [@tag, @value]
    end
  end
end
