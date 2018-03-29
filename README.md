# Marcxella

A simple interface to MARC-XML, for when you just need to parse some
MARC-XML quickly.

Pronounce it "marc-sélla".

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'marcxella'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install marcxella

## Usage

### Documents

records (`Marcxella::Record`) are the main objects you'll be dealing with. To get at the records, you'll probably create a document. This can be done from a filehandle:

    > require "marcxella"
    > file = File.open("spec/xml/1027474578.xml")
    > marc = Marcxella::Document.new(file)
    
You can also create a document from a string of XML:

    > xml = File.open("spec/xml/1027474578.xml").read
    > marc = Marcxella::Document.new(xml)
    
Marxcella uses Nokogiri internally, so you can also just pass a Nokogiri
document:

    > doc = Nokogiri::XML(file)
    > marc = Marcxella::Document.new(doc)
    
Once you have the document, you can get an array of the records:

    > records = marc.records
    
If you want, you can create the records directly from Nokogiri nodes

    > file = File.open("spec/xml/1027474578.xml")
    > doc = Nokogiri::XML(file)
    > records = doc.css('record').map{|r| Marcxella::Record.new(r)}
    
If the xml document contains collections, you can get the collections and then
get the records from those.

    > first_coll = marc.collections.first
    > records = first_coll.records

If the document does contain collections, `Marcxella::Document#records` will
simply ignore the collections and return an array of _all_ the records from
_all_ the collections.

### Records and fields

Once you have a record, you can get the fields by tag:

    > rec = marc.records.first
    > f = rec.field("001")
    
The `#field` method always returns an array, so even when you expect a single
field, you have to get it from the array. There is no distinction made between
repeating and non-repeating fields.

    > control_number = rec.field("001").first
    > title = rec.field("245").first
    > subjects = rec.field("650")

Control fields and Data fields have different classes:

    > control_number.class
     => Marcxella::ControlField
    > title.class
     => Marcxella::DataField

All fields have tags and values:

    > control_number.tag
     => "001"
    > control_number.value
     => "1027474578"

    > title.tag
     => "245"
    > title.value
     => "Kindred /Octavia E. Butler."
     
`#to_s` returns the customary representation of the field data:

    > control_number.to_s
     => "001    1027474578"

    > title.to_s
     => "245  10$aKindred /$cOctavia E. Butler."
    > puts title
    245  10$aKindred /$cOctavia E. Butler.
    
Data fields have subfields. You can get an array of all of them or select an
array of subfields by code.

    > title.subfields.count
     => 2
    > title.subfield("a").first.to_s
     => "$aKindred /"

For compatibility, control fields have these methods, too, which always return
empty arrays:

    > control_number.subfields
     => []
    > control_number.subfield("a")
     => []

Subfields have codes, values, and string representations:

    > subfield = rec.titleStatement.subfield("a").first
    > subfield.code
     => "a"
    > subfield.value
     => "Kindred /"
    > subfield.to_s
     => "$aKindred /"

### Convenience methods

There are several methods to make it easier to get single fields or categories
of fields. `#mainEntry` will return whichever of the 1XX fields the record has
(as a `DataField`, not an array):

    > rec.mainEntry.to_s
     => "100  1\#$aButler, Octavia Estelle$d(1947-2006).$4aut"

`#titleStatement` gets the 245 field (again, as a `DataField` and not an array):

    > rec.titleStatement.value
     => "Kindred /Octavia E. Butler."

There are also methods to get an array of each of the main categories of
fields. Each of these returns an array of all the fields in the record of the
given category:

    > rec.controlFields # 00X
    > rec.codes         # 01X-09X
    > rec.titles        # 20X-24X
    > rec.edition       # 25X-28X
    > rec.description   # 3XX
    > rec.series        # 4XX
    > rec.notes         # 5XX
    > rec.subjects      # 6XX
    > rec.addedEntries  # 70X-75X
    > rec.linking       # 76X-78X
    > rec.seriesAdded   # 80X-83X
    > rec.holdings      # 841-88X

### Leader

You can get the record leader:

    > rec.leader
     => "00000cam a2200000Mi 4500"

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/seanredmond/marcxella. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Marcxella project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/seanredmond/marcxella/blob/master/CODE_OF_CONDUCT.md).
