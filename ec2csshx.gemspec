# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ec2csshx/version'

Gem::Specification.new do |spec|
  spec.name          = "ec2csshx"
  spec.version       = Ec2csshx::VERSION
  spec.authors       = ["bash0C7"]
  spec.email         = ["koshiba+github@4038nullpointer.com"]
  spec.description   = 'Cluster SSH connect to pattern mached hosts (Connected by csshx) (Hosts in ssh config written by ec2ssh)'
  spec.summary       = 'Cluster SSH connect to pattern mached hosts (Connected by csshx) (Hosts in ssh config written by ec2ssh)'
  spec.homepage      = "https://github.com/bash0C7/ec2csshx"
  spec.license       = "Ruby's"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
