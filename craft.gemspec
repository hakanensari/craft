# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'craft/version'

Gem::Specification.new do |gem|
  gem.name          = "craft"
  gem.version       = Craft::VERSION
  gem.authors       = ["Ezekiel Templin", "Hakan Ensari"]
  gem.email         = ["code@papercavalier.com"]
  gem.description   = %q{Data extraction tool}
  gem.summary       = %q{Data extraction tool}
  gem.homepage      = "https://github.com/papercavalier/craft"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
