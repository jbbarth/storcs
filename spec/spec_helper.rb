$:.unshift File.expand_path("../../lib", __FILE__)
require 'storcs'
require 'rspec'
require 'rspec/collection_matchers'

#explicitly enable "should" syntax in rspec 3.x
#see: https://www.relishapp.com/rspec/rspec-expectations/docs/syntax-configuration#disable-should-syntax
RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
