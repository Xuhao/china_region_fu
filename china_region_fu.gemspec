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

  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_dependency 'activesupport'
  spec.add_dependency 'actionpack'
  spec.add_dependency 'httparty'
end
