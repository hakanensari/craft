# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'craft/version'

Gem::Specification.new do |gem|
  gem.name          = 'craft'
  gem.version       = Craft::VERSION
  gem.authors       = ['Hakan Ensari']
  gem.email         = ['hakan.ensari@papercavalier.com']
  gem.summary       = 'Build page objects in Capybara'
  gem.homepage      = 'https://github.com/hakanensari/craft'

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^test/})
  gem.require_paths = ['lib']

  gem.add_dependency 'capybara', '~> 2.1'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'poltergeist'
  gem.add_development_dependency 'rake'
end
