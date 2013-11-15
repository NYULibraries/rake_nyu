# Capistrano::Configuration.instance(:must_exist).load do
  # Set the servers from rails config before we see
  # what's in the rails config environment
  before  "deploy",                             "rails_config:see"
  # before  "deploy:cold",                        "rails_config:see"
  # before  "deploy:setup",                       "rails_config:see"
  before  "deploy:check",                       "rails_config:see"
  # before  "deploy:assets:update_asset_mtimes",  "rails_config:see"
  
  namespace :rails_config do
    # desc "Set stage variables"
    task :set_variables do
      # Configure app_settings from rails_config
      # Defer processing until we have rails environment
      # set(:app_settings, -> { eval(run_locally("rails runner -e #{fetch(:rails_env, 'staging')} 'p Settings.capistrano.to_hash'")) })
      run_locally do
        execute "rails runner -e #{fetch(:rails_env, 'staging')} 'p Settings.capistrano.to_hash'"
      end
      set(:scm_username, ->  { fetch(:app_settings)[:scm_username]} )
      set(:app_path, ->  { fetch(:app_settings)[:path]} )
      set(:user, ->  { fetch(:app_settings)[:user]} )
      set(:puma_ports, ->  { fetch(:app_settings)[:puma_ports]} )
      set(:deploy_to, -> { "#{fetch :app_path}#{fetch :application}"})
    end

    # desc "Set RailsConfig servers"
    task :set_servers do
      server "#{fetch(:app_settings)[:servers].first}", :app, :web, :db, :primary => true
      fetch(:app_settings)[:servers].slice(1, fetch(:app_settings)[:servers].length-1).each do |host|
        server "#{host}", :app, :web
      end
    end

    desc "See RailsConfig settings"
    task :see do
      invoke "rails_config:set_variables" unless fetch(:app_settings)
      $stdout.puts "Variables are set."
      # require 'pry';pry
      
      # invoke "rails_config:set_serves" unless find_servers
      # $stdout.puts "Servers are set."
      p "Settings: #{fetch :app_settings}"
      # p "Servers: #{find_servers}"
      p "SCM Username: #{fetch :scm_username}"
      p "App Path: #{fetch :app_path}"
      p "User: #{fetch :user}"
      p "Deploy To: #{fetch :deploy_to}"
      p "Current path: #{current_path}"
      p "Puma ports: #{fetch :puma_ports}"
    end
  end
# end