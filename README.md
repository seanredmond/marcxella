# Marcxella

A simple interface to MARC-XML, for when you just need to parse some
MARC-XML quickly.

Pronounce it "mar-sélla".

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

### Documents and Collections

Create a `Document` from a file handle:

    marc = Marcxella::Document.new(File.open("marc.xml", "r"))
	
a Nokogiri document:

    doc = File.open("marc.xml") { |f| Nokogiri::XML(f) }
	marc = Marcxella::Document.new(doc)
	
or a string containing the XML:

    xml_str = File.open("marc.xml", "r").read
	marc = Marcxella::Document.new(xml_str)

Depending on the xml, you might fetch records from `Document`:

    records = marc.records

Or collections, which themselves contain records:

    marc.collections.each do |collection|
	  records = collection.records
	end
	
Records and collections can also be created directly from Nokogiri nodes:

    doc = File.open("marc.xml") { |f| Nokogiri::XML(f) }
    records = doc.css("record").map{|r| Marcxella::Record.new(r)}
	
### Records and fields

From a record, you can get a field by its tag. The tag can be a string or an
integer. The result is always an array. No distinction is made between repeating
and non-repeating fields:


    # These all work...
    record.field("245")
    record.field(245)
	record.field("008")
	record.field(8) 
	
Be careful, though. Numbers begining with a 0 are octal numbers, so `010` actually means `8` or `"008"` and `008` is an error. 

    # Don't do this
    record.field(008)

`Record#field` always returns an array:

    > record.field("245").class
     => Array
	> puts record.field("245").first
     => "245  10$aKindred /$cOctavia E. Butler."

There are a few convenience methods. `Record#titleStatement` returns the 245
field (as a `DataField`, not an array).

    > record.titleStatement.class
     => Marcxella::DataField
	> puts record.titleStatement
     => "245  10$aKindred /$cOctavia E. Butler."

`Record#titles` returns an array of all the title and title related fields
(20X-24X)
	
	> record.titles

`Record#mainEntry` will return whichever of the 1XX fields is in the record (there should be only one):

	> puts record.mainEntry.tag
     => "100"

You can get anarray of all the fields:

    record.fields

Control fields and data fields have different classes:

    > record.field("008").first.class
     => Marcxella::ControlField

    > record.field("245").first.class
     => Marcxella::DataField	 
	 
Control fields have `tag` and a `value`:

    > record.field("008").first.tag
     => "008"

    > record.field("008").first.value
     => "180306r20141979xxk    g      000 j eng d"
	 
Data fields, have a `tag` and a `value` as well as two indicators:

    > record.field("245").first.ind1
     => "1"

    > record.field("245").first.ind2
     => "0"

You can retrieve all the subfields, or subfields by code:

    field = record.field("245").first
	field.subfields
	field.subfield("a")

`subfields` and `subfield` both return arrays.
	
Printing a data field (or calling the `#to_s` method) returns the customary representation:

    > record.field("245").first.to_s
     => "245  10$aKindred /$cOctavia E. Butler."

The `#value` of a data field is the contents of the fields joined together

    > record.field("245").first.display
      => "Kindred /Octavia E. Butler."

Subfields have a `code` and a `value` and can be printed:

    > subfield = record.field("100").first.subfield("a").first
	> subfield.code
     => "a"
	> subfield.value
     => "Butler, Octavia Estelle"
	> subfield.to_s
     => "$aButler, Octavia Estelle"

You can also get the subfield from the record by calling `field` with
the tag and code:

    > record.field("100", "a").first.to_s
     => "$aButler, Octavia Estelle"

For compatability, control fields have `#subfield` and `#subfields` methods,
which always return an empty array.

If you want to get multiple fields at once, you can pass an array:

    record.field(["600", "650", "651"])
	
This will return an array of any of those fields that exist in a
record. You can add a code:

    record.field(["600", "650", "651"], "a")
	
This would return an array of 600$a, 650$a, and/or 651$a
subfields. The array can be a list of tag and code pairs:

    record.field([["600", "a"], ["650", "b"], ["651", "c"]])
	
From this you would get an array of the 600$a, 650$b, and 651$c
subfields. Finally, you can mix and match:

	record.field(["600", "650", ["651", "a"]])
	
The resulting array would contain some DataFields (for the 600s and
650s) and some subfields (651$a). An additional code will act as a
default. These two are equivalent:

	record.field(["600", "650", ["651", "a"]], "b")
    record.field([["600", "b"], ["650", "b"], ["651", "a"]])
	

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/seanredmond/marcxella. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Marcxella project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/seanredmond/marcxella/blob/master/CODE_OF_CONDUCT.md).
