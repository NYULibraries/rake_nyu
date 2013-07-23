# Requiring Capistrano for recipes.
require 'capistrano'

# This loads a recipe for precompiling assets, this specific one only precompiles if there are any changes.
require_relative 'assets'
# This recipe clears the cache.
require_relative 'cache'
# Set up multistage.
require_relative 'multistage'
# The rails config recipe loads up all our application specific settings from a settings.yaml
require_relative 'rails_config'
# The bundler recipe sets up a bundler environment with ruby.
require_relative 'bundler'
# The new_relic recipe enables use of new_relic with rake_nyu.
require_relative 'new_relic'
# This recipe sends the git diff between two commits.
require_relative 'send_diff'
# The rvm recipe sets up an rvm environment with ruby.
require_relative 'rvm'
# The default server to use for this recipe is passenger.
require_relative 'server/passenger'
# The default attributes get set here. Apparently it makes more sense to set them at the end, as certain other recipes load up thes
# attributes before a custom overrides.
require_relative 'default_attributes'
# Custom Capistrano tagging
require_relative 'capistrano-tagging'
