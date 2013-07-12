Capistrano::Configuration.instance(:must_exist).load do
  # Hack on Capistrano, Capistrnao requires :repository to be set, and thus is always set with garbage value.
  # This makes it impossible to detect wether or not the user set it, so unsetting here solves that.
  unset :repository
  require_relative 'capistrano-nyu/recipes'
end