# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ransack_wrap/version'

Gem::Specification.new do |spec|
  spec.name          = "ransack_wrap"
  spec.version       = RansackWrap::VERSION
  spec.authors       = ["Tõnis Simo"]
  spec.email         = ["anton.estum@gmail.com"]
  spec.description   = %q{Model-wrappers to customize ransack search}
  spec.summary       = %q{Ransack Wrap helps to customize Ransack searching for each models, it allows to easy overwrite and add search keys, scopes and queries}
  spec.homepage      = "http://github.com/estum/ransack_wrap"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_dependency 'ransack', '>= 1.0.0'
  spec.add_dependency 'active_attr', '>= 0.8.2'
  spec.add_dependency 'activerecord', '>= 3.0.2', "< 4.0"
  spec.add_dependency 'actionpack',   '>= 3.0.2', "< 4.0"
  spec.add_runtime_dependency "activemodel",   ">= 3.0.2", "< 4.0"
  spec.add_runtime_dependency "activesupport", ">= 3.0.2", "< 4.0"
  spec.add_dependency 'polyamorous', '>= 0.5.0'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
