module RakeNyu
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/puma.rake"
      load "tasks/new_relic.rake"
    end
  end
end