require "bundler/capistrano"
# Load rvm-capistrano gem
require "rvm/capistrano"

Capistrano::Configuration.instance(:must_exist).load do
  # Make sure correct ruby is installed
  before  "deploy",         "rvm:install_ruby"
  # After your bundle has installed, do any migrations
  after   "bundle:install", "deploy:migrate"
  
  # RVM  vars
  set :rvm_ruby_string, fetch(:rvm_ruby_string, "ruby-1.9-p448")
  set :rvm_type, :user
  
  # Bundler vars
  set :bundle_without, [:development, :test]
end