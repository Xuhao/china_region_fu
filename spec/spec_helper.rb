require 'pry-byebug'
require 'codacy-coverage'
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'china_region_fu'
Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

Codacy::Reporter.start
