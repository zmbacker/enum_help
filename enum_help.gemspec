# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "enum_help/version"

Gem::Specification.new do |spec|
  spec.name          = "enum_help"
  spec.version       = EnumHelp::VERSION
  spec.authors       = ["Lester Zhao"]
  spec.email         = ["zm.backer@gmail.com"]
  spec.summary       = %q{ Extends of ActiveRecord::Enum, which can used in simple_form and internationalization }
  spec.description   = %q{ Help ActiveRecord::Enum feature to work fine with I18n and simple_form.  }
  spec.homepage      = "https://github.com/zmbacker/enum_help"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 3.0.0"
end
