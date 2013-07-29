module NyuLibraries
  require "require_all"
  require_relative 'nyulibraries/deploy'
  require_all "#{File.dirname(__FILE__)}/rake_nyu/"
end