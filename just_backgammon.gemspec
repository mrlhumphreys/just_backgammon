# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'just_backgammon/version'

Gem::Specification.new do |spec|
  spec.name          = "just_backgammon"
  spec.version       = JustBackgammon::VERSION
  spec.authors       = ["Mark Humphreys"]
  spec.email         = ["mark@mrlhumphreys.com"]

  spec.summary       = %q{A backgammon engine written in ruby}
  spec.description   = %q{Provides a representation of a backgammon game complete with rules enforcement and serialisation.}
  spec.homepage      = "https://github.com/mrlhumphreys/just_backgammon"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.7'

  spec.add_development_dependency "bundler", "~> 2.1.4"
  spec.add_development_dependency "rake", "~> 13.0.1"
  spec.add_development_dependency "minitest", "~> 5.14.0"
end
