module RakeTasksNyu
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/rake_nyu.rake"
    end
  end
end
