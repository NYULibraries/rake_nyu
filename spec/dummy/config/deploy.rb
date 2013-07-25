require File.join(File.dirname(__FILE__), '../../../lib/nyulibraries/deploy/', 'capistrano')

set :app_title, "rake_nyu"
set :branch, "devel"
set :scm, :git
set :bundle_flags, "--quiet"

namespace :deploy do
  task :migrate do
    # Do NOTHING
  end
end

namespace :deploy do
  namespace :assets do
    desc "Precompiles if assets have been changed"
    task :precompile, :roles => :web, :except => { :no_release => true } do
      # DO NOTHING!!
    end
  end
end

namespace :newrelic do
  task :set do
    # DO NOTHING!!!
  end

  desc "Reset the New Relic file"
  task :reset do
    # DO NOTHING!!!!!!
  end
end