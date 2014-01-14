# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'katte/version'

Gem::Specification.new do |gem|
  gem.name          = "katte"
  gem.version       = Katte::VERSION
  gem.authors       = ["Ojima Hikaru"]
  gem.email         = ["ojiam.h@gmail.com"]
  gem.description   = %q{Batch job management tool.}
  gem.summary       = %q{Batch job management tool.}
  gem.homepage      = "https://github.com/ojima-h/katte"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
