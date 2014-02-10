# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qrcode/version'

Gem::Specification.new do |spec|
  spec.name          = "qrcode"
  spec.version       = Qrcode::VERSION
  spec.authors       = ["Nathan Amick"]
  spec.email         = ["github@nathanamick.com"]
  spec.description   = %q{Generate QR Codes on the command line}
  spec.summary       = %q{Generate QR Codes on the command line}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rqrcode"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
