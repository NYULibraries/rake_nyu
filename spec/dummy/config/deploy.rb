require File.join(File.dirname(__FILE__), '../../../lib/nyulibraries/deploy/', 'capistrano')

set :app_title, "nyulibraries_deploy"
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

namespace :cache do
  desc "Clear rails cache"
  task :tmp_clear, :roles => :app do
    # DO NOTHING!!!!!!!!!!!!
  end
end

namespace :tagging do
  task :deploy do
    if tagging_environment?
      run_locally "git tag #{NyuLibraries::VERSION} #{revision} -m \"Deployed by #{user_name} <#{user_email}>\""
      run_locally "git push #{remote} refs/tags/#{NyuLibraries::VERSION}:refs/tags/#{NyuLibraries::VERSION}"
    else
      logger.info "ignored git tagging in #{fetch(:rails_env, fetch(:stage, 'staging'))} environment"
    end
  end
end