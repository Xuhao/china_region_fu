# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "china_region_fu/version"

Gem::Specification.new do |s|
  s.name        = "china_region_fu"
  s.version     = ChinaRegionFu::VERSION
  s.authors     = ["xuhao"]
  s.email       = ["xuhao@rubyfans.com"]
  s.homepage    = ""
  s.summary     = %q{china region}
  s.description = %q{china region}

  s.rubyforge_project = "china_region_fu"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
