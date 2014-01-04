$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sourcebuster/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sourcebuster"
  s.version     = Sourcebuster::VERSION.dup
  s.authors     = ["Alex Fedoseev"]
  s.email       = ["alex.fedoseev@gmail.com"]
  s.homepage    = "http://www.alexfedoseev.com"
  s.summary     = "Sourcebuster tracks sources of your visitors"
  s.description = "It stores information about visitor's sources, handles sources overriding just like Google Analytics do and lets you store this info for further analysis."
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.license     = "MIT"

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables      = [] # `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }

  s.add_dependency "rails", "~> 4.0.2"
  s.add_dependency "jquery-rails"
  s.add_development_dependency "selenium-webdriver", "~> 2.39.0"
  s.add_development_dependency "pg"
end
