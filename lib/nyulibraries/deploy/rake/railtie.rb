module NyuLibraries
  if defined?(::Rails) && ::Rails.version >= '3.1.0'
    class Railtie < Rails::Railtie
      rake_tasks do
        load "nyulibraries/deploy/rake/puma.rake"
        load "nyulibraries/deploy/rake/new_relic.rake"
      end
    end
  else
    require 'rake'
    class TaskInstaller
      include Rake::DSL if defined? Rake::DSL
      class << self
        def install_tasks
          @rake_tasks ||= []
          @rake_tasks << load("nyulibraries/deploy/rake/puma.rake")
          @rake_tasks << load("nyulibraries/deploy/rake/new_relic.rake")
          @rake_tasks
        end
      end
    end
    # Install tasks
    NyuLibraries::TaskInstaller.install_tasks
  end
end