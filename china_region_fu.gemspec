# -*- encoding: utf-8 -*-
require File.expand_path('../lib/china_region_fu/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Xuhao"]
  gem.email         = ["xuhao@rubyfans.com"]
  gem.description   = %q{China region Ruby on rails interface}
  gem.summary       = %q{China region Ruby on rails interface}
  gem.homepage      = "http://rubyfans.com"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "china_region_fu"
  gem.require_paths = ["lib"]
  gem.version       = ChinaRegionFu::VERSION
end
