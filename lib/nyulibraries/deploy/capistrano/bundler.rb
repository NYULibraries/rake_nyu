# Load Bundler cap recipe
require "bundler/capistrano"

Capistrano::Configuration.instance(:must_exist).load do
  # After your bundle has installed, do any migrations
  after "bundle:install", "deploy:migrate"
end