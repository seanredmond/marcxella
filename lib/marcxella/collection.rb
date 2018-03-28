module Marcxella
  # Wrapper for a collection element, which contains 0 or more record
  #   elements
  # @since 0.1.0
  class Collection
    def initialize(node)
      @node = node
    end

    # @return [Array<Record>] the records in the container
    def records
      @node.css('record').map{|r| Record.new(r)}
    end
  end
end
