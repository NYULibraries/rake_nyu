$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "nyulibraries/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "nyulibraries_deploy"
  s.version     = NyuLibraries::VERSION
  s.authors     = ["Scot Dalton"]
  s.email       = ["scot.dalton@nyu.edu"]
  s.homepage    = "https://github.com/NYULibraries/nyulibraries_deploy"
  s.summary     = "Common deploy tasks for the NYU Libraries."
  s.description = "Common deploy tasks for the NYU Libraries."

  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rake", "~> 10.0.4"
  s.add_dependency "require_all", "~> 1.2.1"
  s.add_dependency "rails", "~> 3.2.13"
  s.add_development_dependency "rspec", "~> 2.14.0"
  
  s.add_dependency "cap_git_tools", "~> 0.9.1"
  s.add_dependency "git", "~> 1.2.5"
  s.add_dependency "mail", "~> 2.5.4"
  s.add_dependency "octokit", "~> 1.25.0"
  s.add_dependency "rails_config", "~> 0.3.2"
  s.add_dependency "capistrano", "~> 2.15.5"
  s.add_dependency "rvm-capistrano", "~> 1.4.0"
  s.add_dependency "newrelic_rpm", "~> 3.6.0"
  s.add_dependency "rails_config", "~> 0.3.2"
end
