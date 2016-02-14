$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "action_bouncer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "action_bouncer"
  s.version     = ActionBouncer::VERSION
  s.authors     = ["Oswaldo Ferreira"]
  s.email       = ["oswluizf@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of ActionBouncer."
  s.description = "TODO: Description of ActionBouncer."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5.1"
  s.add_dependency "rspec-rails", "~> 3.4.2"
  s.add_dependency "pry"

  s.add_development_dependency "sqlite3"
end
