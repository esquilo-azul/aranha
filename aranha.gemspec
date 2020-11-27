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
  s.summary     = 'Rails utilities for web crawling.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'aranha-parsers', '~> 0.4'
  s.add_dependency 'aranha-selenium', '~> 0.1', '>= 0.1.2'
  s.add_dependency 'eac_ruby_utils', '~> 0.52'
  s.add_dependency 'httpclient', '>= 2.6'
  s.add_dependency 'rails', '>= 4.2.11.3'

  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.1'
end
