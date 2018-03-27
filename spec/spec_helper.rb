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
