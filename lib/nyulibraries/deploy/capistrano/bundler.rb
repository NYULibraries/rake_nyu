# Load Bundler cap recipe
require "bundler/capistrano"

Capistrano::Configuration.instance(:must_exist).load do
  # After your bundle has installed, do any migrations
  after "bundle:install", "deploy:migrate"
  after "bundle:install", "bundle:clean"
  
  namespace :bundle do
    desc "Clear rails cache"
    task :clean do
     run "cd #{current_release} && bundle clean"
    end
  end
end