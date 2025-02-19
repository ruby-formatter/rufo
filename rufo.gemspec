# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rufo/version"

Gem::Specification.new do |spec|
  spec.name = "rufo"
  spec.version = Rufo::VERSION
  spec.authors = ["Ary Borenszweig"]
  spec.email = ["asterite@gmail.com"]

  spec.summary = %q{Ruby code formatter}
  spec.description = %q{Fast and unobtrusive Ruby code formatter}
  spec.homepage = "https://github.com/ruby-formatter/rufo"
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 3.0.0"
  spec.metadata["rubygems_mfa_required"] = "true"
end
