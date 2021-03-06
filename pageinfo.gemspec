# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pageinfo/version'

Gem::Specification.new do |spec|
  spec.name          = "pageinfo"
  spec.version       = Pageinfo::VERSION
  spec.authors       = ["aditiamahdar"]
  spec.email         = ["adit@41studio.com"]

  spec.summary       = %q{Browse your page meta info and optimize your SEO strategy.}
  spec.description   = %q{Page Info gem will browse through your site then list every page on your site and give detail meta info about the page.}
  spec.homepage      = "https://github.com/aditiamahdar/pageinfo"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "typhoeus", "~> 0.7"
  spec.add_dependency "nokogiri", "~> 1.6"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
end
