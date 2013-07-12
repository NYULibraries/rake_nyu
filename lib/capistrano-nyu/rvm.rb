require "bundler/capistrano"
# Load rvm-capistrano gem
require "rvm/capistrano"

Capistrano::Configuration.instance(:must_exist).load do
  # Make sure correct ruby is installed
  before  "deploy",         "rvm:install_ruby"
  # After your bundle has installed, do any migrations
  after   "bundle:install", "deploy:migrate"
  
  # RVM  vars
  set :rvm_ruby_string, fetch(:rvm_ruby_string, "ruby-1.9.3-p448")
  set :rvm_type, :user
  
  # Rails specific vars
  set :normalize_asset_timestamps, false
  
  # Bundler vars
  set :bundle_without, [:development, :test]
end