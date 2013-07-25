require File.join(File.dirname(__FILE__), '../../../lib', 'capistrano-nyu')

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