# Include New Relic recipes
require 'new_relic/recipes'

Capistrano::Configuration.instance(:must_exist).load do
  before  "newrelic:notice_deployment", "newrelic:set"
  # After newrelic runs, reset up its yaml file
  after   "newrelic:notice_deployment", "newrelic:reset"
  after   "deploy:update",              "newrelic:notice_deployment"
  

  namespace :newrelic do
    desc "Write New Relic file without ERB for processing by New Relic rpm recipe"
    task :set do
      run_locally "bundle exec rake nyu:newrelic:set RAILS_ENV=#{fetch(:rails_env, 'staging')}"
    end

    desc "Reset the New Relic file"
    task :reset do
      run_locally "bundle exec rake nyu:newrelic:reset RAILS_ENV=#{fetch(:rails_env, 'staging')} "
    end
  end
end
