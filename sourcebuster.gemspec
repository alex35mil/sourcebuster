$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sourcebuster/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sourcebuster"
  s.version     = Sourcebuster::VERSION
  s.authors     = ["Alex Fedoseev"]
  s.email       = ["alex.fedoseev@gmail.com"]
  s.homepage    = "http://www.alexfedoseev.com"
  s.summary     = "Sourcebuster tracks sources of your visitors"
  s.description = "It stores information about visitor's sources, handles sources overriding just like Google Analytics do and lets you store this info for further analysis."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.2"
  s.add_dependency "jquery-rails"

  s.add_development_dependency "pg"
end
