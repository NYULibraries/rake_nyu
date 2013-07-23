Capistrano::Configuration.instance(:must_exist).load do
  # Requiring the default recipe list, will make most apps have a two line long deploy.rb file.
  require_relative 'capistrano-nyu/default_recipes'
end