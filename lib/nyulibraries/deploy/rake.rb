module NyuLibraries
  module Deploy
    require_relative 'newrelic_manager'
    require_relative 'puma_config'
    require_relative 'puma_manager'
    require_relative 'rake/railtie'
  end
end