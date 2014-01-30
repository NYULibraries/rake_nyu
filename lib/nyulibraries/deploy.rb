module NyuLibraries
  module Deploy
    require_relative 'deploy/newrelic_manager'
    require_relative 'deploy/puma_config'
    require_relative 'deploy/puma_manager'
    require_relative 'deploy/rake'
  end
end
