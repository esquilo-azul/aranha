# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'aranha/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'aranha'
  s.version     = Aranha::VERSION
  s.authors     = ['Eduardo H. Bogoni']
  s.email       = ['eduardobogoni@gmail.com']
  s.summary     = 'Ruby utilities for web crawling.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'README.rdoc']
  s.required_ruby_version = '>= 2.7.0'

  s.add_dependency 'aranha-selenium', '~> 0.5'
  s.add_dependency 'eac_ruby_utils', '~> 0.128'

  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.12'
end
