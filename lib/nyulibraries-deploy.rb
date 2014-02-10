module Nyulibraries
  module Deploy
    require_relative 'nyulibraries/deploy'
    load File.expand_path('../capistrano/nyulibraries_deploy.rb', __FILE__)
  end
end
