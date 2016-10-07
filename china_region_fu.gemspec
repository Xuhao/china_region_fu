lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'china_region_fu/version'

Gem::Specification.new do |spec|
  spec.name          = 'china_region_fu'
  spec.version       = ChinaRegionFu::VERSION
  spec.authors       = ['Xuhao']
  spec.email         = ['xuhao@rubyfans.com']
  spec.summary       = 'china_region_fu provides simple helpers to get an HTML select list of countries, cities and districts.'
  spec.description   = 'china_region_fu provides simple helpers to get an HTML select list of countries, cities and districts.'
  spec.homepage      = 'https://github.com/Xuhao/china_region_fu'
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = Dir['spec/**/*']
  spec.require_paths = ['lib']
  spec.required_ruby_version     = '>= 2.2.2'
  spec.required_rubygems_version = '>= 1.8.11'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_dependency 'activesupport', '>= 4.0'
  spec.add_dependency 'httparty', '~> 0.14.0'
end
