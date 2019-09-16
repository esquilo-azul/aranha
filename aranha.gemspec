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

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'active_scaffold', '>= 3.4.41.1'
  s.add_dependency 'aranha-parsers', '~> 0.1', '>= 0.1.1'
  s.add_dependency 'eac_ruby_utils', '~> 0.10', '>= 0.10.1'
  s.add_dependency 'httpclient', '>= 2.6'
  s.add_dependency 'rails', '~> 4.2.10'
  s.add_dependency 'selenium-webdriver', '~> 3.142', '>= 3.142.3'

  s.add_development_dependency 'rspec', '~> 3.8'
  s.add_development_dependency 'sqlite3'
end
