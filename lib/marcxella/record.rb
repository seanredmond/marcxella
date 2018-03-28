module Marcxella

  # Wrapper for a record element
  # @since 0.1.0
  # @attr_reader [Nokogiri::XML::Document] node the wrapped record element node
  # @attr_reader [String] leader the record leader
  class Record
    attr_reader :node, :leader
    def initialize(node)
      @node = node
      @leader = node.css('leader').text
    end

    # Get fields by a tag, or a subfields by a tag and code.
    # @param tag [String, Integer] Tag of the field to get. There is a potential
    #   gotcha when using integers  Since MARC field tags are usually shown as
    #   0-padded, three-digit numbers such as "010", it would be natural to
    #   pass 010 as the tag, but to Ruby the leading zero means that it is an
    #   octal number, so 010 means "008".
    # @param code [String] Subfield code. When not nil, retun value will be an
    #   Array of SubField objects that are children of the DataField with the
    #   matching tag and have the matching code. Note that this may return
    #   subfields of _different_ datafields.
    # @return [Array<DataField>, Array<ControlField>, Array<SubField>] The
    #   return type will depend on the tag being requested.
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

    # The control and data fields of the record
    # @return [Array<ControlField, DataField>]
    def fields
      @node.css('controlfield, datafield').map{|f| objectify f}
    end

    # Does the record include a field with a specific tag?
    # @return [boolean] true if there is at least one control or data field
    #   with the specified tag.
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

    private :objectify
  end
end
