module NyuLibraries
  if defined?(::Rails) && ::Rails.version >= '3.1.0'
    class Railtie < Rails::Railtie
      rake_tasks do
        load "puma.rake"
        load "new_relic.rake"
      end
    end
  else
    require 'rake'
    class TaskInstaller
      include Rake::DSL if defined? Rake::DSL
      class << self
        def install_tasks
          @rake_tasks ||= []
          @rake_tasks << load("puma.rake")
          @rake_tasks << load("new_relic.rake")
          @rake_tasks
        end
      end
    end
    # Install tasks
    RakeNyu::TaskInstaller.install_tasks
  end
end