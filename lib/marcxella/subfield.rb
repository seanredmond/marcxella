module Marcxella
  class SubField
    attr_reader :code, :value
    def initialize(node)
      @code = node['code']
      @value = node.text
    end
    
      def to_s
        "$%s%s" % [@code, @value]
      end
  end
end
