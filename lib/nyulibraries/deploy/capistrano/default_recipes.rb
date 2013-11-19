# Overrideable defaults.
require_relative 'default_attributes'
# The rails config recipe loads up all our application specific settings from a settings.yaml
require_relative 'server_config'
# This loads a recipe for precompiling assets, this specific one only precompiles if there are any changes.
# require_relative 'rails/assets'
# The bundler recipe sets up a bundler environment with ruby.
require_relative 'bundler'
# The rvm recipe sets up an rvm environment with ruby.
require_relative 'rvm'
# The new_relic recipe enables use of new_relic with rake_nyu.
require_relative 'new_relic'
# The default server to use for this recipe is passenger.
require_relative 'server/passenger'
# Custom Capistrano tagging
require_relative 'tagging'
# This recipe clears the cache.
# require_relative 'rails/cache'
