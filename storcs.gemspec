# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "storcs/version"

Gem::Specification.new do |s|
  s.name        = "storcs"
  s.version     = Storcs::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jean-Baptiste Barth"]
  s.email       = ["jeanbaptiste.barth@gmail.com"]
  s.homepage    = "http://github.com/jbbarth/storcs"
  s.summary     = %q{Storage-related calculations}
  s.description = %q{Storage-related calculations. Helps you manage your storage devices such as SAN, NAS, etc. in your CMDB}

  s.add_development_dependency "rspec"

  s.rubyforge_project = "storcs"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
