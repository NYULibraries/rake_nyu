# Include New Relic recipes
require 'new_relic/recipes'

Capistrano::Configuration.instance(:must_exist).load do
  # Set the servers from rails config before we see
  # what's in the rails config environment
  before  "rails_config:set_servers",   "rails_config:set_variables"
  before  "rails_config:see",           "rails_config:set_servers"
  on      :start,                       "rails_config:see"
  
  namespace :rails_config do
    desc "Set stage variables"
    task :set_variables do
      # Configure app_settings from rails_config
      # Defer processing until we have rails environment
      set(:app_settings)  { eval(run_locally("rails runner -e #{rails_env} 'p Settings.capistrano.to_hash'")) }
      set(:scm_username)  { app_settings[:scm_username] }
      set(:app_path)      { app_settings[:path] }
      set(:user)          { app_settings[:user] }
      set(:puma_ports)    { app_settings[:puma_ports] }
      set(:deploy_to)     {"#{fetch :app_path}#{fetch :application}"}
    end

    desc "Set RailsConfig servers"
    task :set_servers do
      server "#{app_settings[:servers].first}", :app, :web, :db, :primary => true
      app_settings[:servers].slice(1, app_settings[:servers].length-1).each do |host|
        server "#{host}", :app, :web
      end
    end

    desc "See RailsConfig settings"
    task :see do
      p "Settings: #{fetch :app_settings}"
      p "Servers: #{find_servers}"
      p "SCM Username: #{fetch :scm_username}"
      p "App Path: #{fetch :app_path}"
      p "User: #{fetch :user}"
      p "Deploy To: #{fetch :deploy_to}"
      p "Current path: #{current_path}"
      p "Puma ports: #{fetch :puma_ports}"
    end
  end
end