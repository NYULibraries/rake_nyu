require "bundler/capistrano"
# Load rvm-capistrano gem
require "rvm/capistrano"

Capistrano::Configuration.instance(:must_exist).load do
  # Make sure correct ruby is installed
  before  "deploy",         "rvm:install_ruby"
  # After your bundle has installed, do any migrations
  after   "bundle:install", "deploy:migrate"
end