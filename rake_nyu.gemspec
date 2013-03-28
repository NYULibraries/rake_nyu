$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rake_nyu/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rake_nyu"
  s.version     = RakeNyu::VERSION
  s.authors     = ["Scot Dalton"]
  s.email       = ["scot.dalton@nyu.edu"]
  s.homepage    = "https://github.com/NYULibraries/rake_nyu"
  s.summary     = "Common rake tasks for the NYU Libraries."
  s.description = "Common rake tasks for the NYU Libraries."

  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rake", "~> 10.0.4"
  s.add_dependency "require_all", "~> 1.2.1"
  s.add_development_dependency "rspec", "~> 2.13.0"
end
