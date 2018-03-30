module Marcxella

  # A control field (00X). Control fields have a value but no subfields
  # @since 0.1.0
  # @attr_reader [String] tag the field tag
  # @attr_reader [String] value the field value
  # @attr_reader [Array] For compatability. Always an empty array
  # @see https://www.loc.gov/marc/bibliographic/bd00x.html
  #   00X - Control Fields-General Information
  #
  class ControlField
    attr_reader :tag, :value, :subfields
    def initialize(node)
      @tag = node['tag']
      @value = node.text
      @subfields = []
    end

    # a string representation of the field.
    # @return [String]
    def to_s
      "%s    %s" % [@tag, @value]
    end

    # For compatability. Always returns an empty array because control fields
    # don't have subfields
    # @return Array an empty array
    def subfield(code)
      []
    end

    def [](code)
      []
    end
  end
end
