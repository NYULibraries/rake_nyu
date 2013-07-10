require 'capistrano'
require "bundler/capistrano"
# Load rvm-capistrano gem
require "rvm/capistrano"

Capistrano::Configuration.instance(:must_exist).load do
  # Make sure correct ruby is installed
  before  "deploy",         "rvm:install_ruby"
  before  "deploy",         "rvm:get_user"
  # After your bundle has installed, do any migrations
  after   "bundle:install", "deploy:migrate"
  
  # RVM  vars
  set :rvm_ruby_string, fetch(:rvm_ruby_string, "ruby-1.9-p448")
  namespace :rvm do
    task :get_user do
      set :rvm_type, fetch(:user)
    end
  end
  
  # Bundler vars
  set :bundle_without, [:development, :test]
end