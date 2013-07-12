Capistrano::Configuration.instance(:must_exist).load do
  # Hack on Capistrano, Capistrnao requires :repository to be set, and thus is always set with garbage value.
  # This makes it impossible to detect wether or not the user set it, so unsetting here solves that.
  unset :repository
  
  # Requiring the default recipe list, will make most apps have a two line long deploy.rb file.
  require_relative 'capistrano-nyu/default_recipes'
end