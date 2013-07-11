Capistrano::Configuration.instance(:must_exist).load do
  unset :repository
  require_relative 'capistrano-nyu/recipes'
end