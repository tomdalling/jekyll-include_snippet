# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jekyll/include_snippet/version"

Gem::Specification.new do |spec|
  spec.name          = "jekyll-include_snippet"
  spec.version       = Jekyll::IncludeSnippet::VERSION
  spec.authors       = ["Tom Dalling"]
  spec.email         = ["tom@tomdalling.com"]

  spec.summary       = %q{Include snippets of text from external files into your markdown}
  spec.homepage      = "https://github.com/tomdalling/jekyll-include_snippet"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'liquid', '>= 3.0'

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rspec", "~> 3.7"
  spec.add_development_dependency "rspec-its", "~> 1.2"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "gem-release"
end
