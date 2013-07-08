# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'china_region_fu/version'

Gem::Specification.new do |spec|
  spec.name          = "china_region_fu"
  spec.version       = ChinaRegionFu::VERSION
  spec.authors       = ["Xuhao"]
  spec.email         = ["xuhao@rubyfans.com"]
  spec.description   = %q{China region Ruby on rails interface}
  spec.summary       = %q{China region Ruby on rails interface}
  spec.homepage      = "https://github.com/Xuhao/china_region_fu"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_dependency 'activesupport'
  spec.add_dependency 'actionpack'
end