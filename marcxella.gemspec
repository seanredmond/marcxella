
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "marcxella/version"

Gem::Specification.new do |spec|
  spec.name          = "marcxella"
  spec.version       = Marcxella::VERSION
  spec.authors       = ["Sean Redmond"]
  spec.email         = ["github-smr@sneakemail.com"]

  spec.summary       = %q{Little library for reading MARC-XML.}
  spec.description   = %q{A little library for reading MARC-XML, for when you just need to deal with it quickly.}
  spec.homepage      = "https://github.com/seanredmond/marcxella"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
