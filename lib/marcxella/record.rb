module Marcxella

  # Wrapper for a record element
  # @since 0.1.0
  # @attr_reader [Nokogiri::XML::Document] node the wrapped record element node
  # @attr_reader [String] leader the record leader
  class Record
    attr_reader :node, :leader, :fields
    def initialize(node)
      @node = node
      @leader = node.css('leader').text
      @fields = node.css('controlfield, datafield').map{|f| objectify f}
    end

    # Get fields by a tag
    # @param tag [String] Tag of the field to get.
    # @return [Array<DataField>, Array<ControlField>] The
    #   return type will depend on the tag being requested.
    def field(tag)
      return @fields.select{|f| f.tag == tag}
    end

    # The control and data fields of the record
    # @return [Array<ControlField, DataField>]
    def fields
      @node.css('controlfield, datafield').map{|f| objectify f}
    end

    # Does the record include a field with a specific tag?
    #
    # @return [boolean] true if there is at least one control or data field
    #   with the specified tag.
    def include?(tag, code = nil)
      not field(tag, code).empty?
    end

    # The record's main entry field. Every record should have one (and only
    # one) of the 1XX fields (100, 110, 111, 130).
    #
    # @since 0.1.0
    # @return [DataField]
    # @see https://www.loc.gov/marc/bibliographic/bd1xx.html
    #   1XX - Main Entries-General Information
    def mainEntry
      tag_range("100", "1XX").first
    end

    # The record's title statement. That is, its 245 field
    #
    # @since 0.1.0
    # @return [DataField]
    # @see https://www.loc.gov/marc/bibliographic/bd245.html
    #   245 - Title Statement
    def titleStatement
      field("245").first
    end

    # The control fields (00X)
    # @since 0.1.0
    # @return [Array<ControlField>]
    # @see https://www.loc.gov/marc/bibliographic/bd00x.html
    #   00X - Control Fields-General Information
    def controlFields
      tag_range("001", "009")
    end

    # The numbers and code fields (01X-09X)
    # @since 0.1.0
    # @return [Array<DataField>]
    # @see https://www.loc.gov/marc/bibliographic/bd01x09x.html
    #   01X-09X - Numbers and Codes-General Information
    def codes
      tag_range("010", "09X")
    end
    
    # The title- and title-related fields (20X-24X)
    # @since 0.1.0
    # @return [Array<DataField>]
    # @see https://www.loc.gov/marc/bibliographic/bd20x24x.html
    #   20X-24X - Title and Title-Related Fields - General Information
    def titles
      tag_range("200", "24X2")
    end

    # The edition- and imprint-related fields (25X-28X)
    # @since 0.1.0
    # @return [Array<DataField>]
    # @see https://www.loc.gov/marc/bibliographic/bd25x28x.html
    #   25X-28X - Edition, Imprint, Etc. Fields-General Information
    def edition
      tag_range("250", "28X")
    end

    # The physical description fields (3XX)
    # @since 0.1.0
    # @return [Array<DataField>]
    # @see https://www.loc.gov/marc/bibliographic/bd3xx.html
    #   3XX - Physical Description, Etc. Fields - General Information
    def description
      tag_range("300", "399")
    end

    # The series statement fields (4XX)
    # @since 0.1.0
    # @return [Array<DataField>]
    # @see https://www.loc.gov/marc/bibliographic/bd4xx.html
    #   4XX - Series Statement Fields (4XX)
    def series
      tag_range("400", "499")
    end

    # The note statement fields (5XX)
    # @since 0.1.0
    # @return [Array<DataField>]
    # @see https://www.loc.gov/marc/bibliographic/bd5xx.html
    #   5XX - Note Fields - General Information
    def notes
      tag_range("500", "59X")
    end

    # The subject access fields (6XX)
    # @since 0.1.0
    # @return [Array<DataField>]
    # @see https://www.loc.gov/marc/bibliographic/bd6xx.html
    #   6XX - Subject Access Fields-General Information
    def subjects
      tag_range("600", "69X")
    end

    # The added entry fields (70X-75X)
    # @since 0.1.0
    # @return [Array<DataField>]
    # @see https://www.loc.gov/marc/bibliographic/bd70x75x.html
    #   70X-75X - Added Entry Fields - General Information
    def addedEntries
      tag_range("700", "75X")
    end

    # The linking entry fields (76X-78X)
    # @since 0.1.0
    # @return [Array<DataField>]
    # @see https://www.loc.gov/marc/bibliographic/bd76x78x.html
    #   76X-78X - Linking Entries-General Information
    def linking
      tag_range("760", "78X")
    end

    # The series added entry fields (80X-83X)
    # @since 0.1.0
    # @return [Array<DataField>]
    # @see https://www.loc.gov/marc/bibliographic/bd80x83x.html
    #   80X-83X - Series Added Entry Fields
    def seriesAdded
      tag_range("800", "83X")
    end

    # The holdings, alternate graphics, etc fields (841-88X)
    # @since 0.1.0
    # @return [Array<DataField>]
    # @see https://www.loc.gov/marc/bibliographic/bd84188x.html
    #   841-88X - Holdings, Alternate Graphics, Etc.-General Information
    def holdings
      tag_range("841", "88X")
    end
    
    def objectify(f)
      if f.name == 'controlfield'
        return ControlField.new(f)
      else
        return DataField.new(f)
      end

      raise "Wha?"
    end

    def tag_range(first, last)
      @fields.select{|f| f.tag >= first and f.tag <= last}
    end

    private :objectify, :tag_range
  end
end
