Capistrano::Configuration.instance(:must_exist).load do
  require_relative 'capistrano-nyu/recipes'
end