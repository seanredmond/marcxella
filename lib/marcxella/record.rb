module Marcxella
  class Record
    attr_reader :node, :leader
    def initialize(node)
      @node = node
      @leader = node.css('leader').text
    end

    def field(tag, code = nil)
      if tag.is_a?(Integer)
        tag = "%0.3d" % [tag]
      end

      if code.nil?
        return @node.
          css("controlfield[tag=\"%s\"], datafield[tag=\"%s\"]" % [tag, tag]).
          map{|f| objectify(f)}
      end

      field(tag).map{|f| f.subfield(code)}.flatten
    end

    def fields
      @node.css('controlfield, datafield').map{|f| objectify f}
    end

    def include?(tag, code = nil)
      not field(tag, code).empty?
    end

    def objectify(f)
      if f.name == 'controlfield'
        return ControlField.new(f)
      else
        return DataField.new(f)
      end

      raise "Wha?"
    end
  end
end
