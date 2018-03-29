require "bundler/setup"
require "marcxella"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

SPEC_DIR = File.dirname(__FILE__)
XML_DIR = File.join(SPEC_DIR, 'xml')
XML_BUTLER = File.join(XML_DIR, '1027474578.xml')
XML_LENGLE = File.join(XML_DIR, '14026028.xml')
XML_QUILT  = File.join(XML_DIR, '10705.xml')
XML_OKORAFOR = File.join(XML_DIR, '973807354.xml')
XML_ELIOT = File.join(XML_DIR, '2971.xml')
XML_RUSSIAN = File.join(XML_DIR, '528635.xml')
XML_XENOPHON = File.join(XML_DIR, '3863.xml')
XML_FISSURES = File.join(XML_DIR, '53998.xml')
