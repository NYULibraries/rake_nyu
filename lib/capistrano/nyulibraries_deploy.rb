require 'capistrano'
require 'capistrano/bundler'
require 'capistrano/rvm'

load File.expand_path('../tasks/defaults.cap', __FILE__)
load File.expand_path('../tasks/server_config.cap', __FILE__)
load File.expand_path('../tasks/tagging.cap', __FILE__)
load File.expand_path('../tasks/bundler.cap', __FILE__)
load File.expand_path('../tasks/rvm.cap', __FILE__)
load File.expand_path('../tasks/rpm.cap', __FILE__)