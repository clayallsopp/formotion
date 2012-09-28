# -*- encoding: utf-8 -*-
require File.expand_path('../lib/formotion/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "formotion"
  s.version     = Formotion::VERSION
  s.authors     = ["Clay Allsopp"]
  s.email       = ["clay.allsopp@gmail.com"]
  s.homepage    = "https://github.com/clayallsopp/Formotion"
  s.summary     = "Making iOS Forms insanely great with RubyMotion"
  s.description = "Making iOS Forms insanely great with RubyMotion"

  s.files         = `git ls-files`.split($\)
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency "bubble-wrap", ">= 1.1.4"
  s.add_development_dependency 'rake'
end