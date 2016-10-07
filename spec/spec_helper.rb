$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pry-byebug'
require 'china_region_fu'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }
