# Capistrano::Configuration.instance(:must_exist).load do
  # Set the servers from rails config before we see
  # what's in the rails config environment
  # before  "deploy",                             "server_config:see"
  # # before  "deploy:cold",                        "server_config:see"
  # # before  "deploy:setup",                       "server_config:see"
  # before  "deploy:check",                       "server_config:see"
  # # before  "deploy:assets:update_asset_mtimes",  "server_config:see"
  before 'deploy:started', 'server_config:see'
  
  namespace :server_config do
    # desc "Set stage variables"
    task :set_variables do
      puts "TASK:\tserver_config:set_variables  =>  Setting app settings and variables...."
      # Configure app_settings from server_config
      # Defer processing until we have rails environment
      # set(:app_settings, -> { eval(run_locally("rails runner -e #{fetch(:rails_env, 'staging')} 'p Settings.capistrano.to_hash'")) })
      # run_locally do
      #   execute "rails runner -e #{fetch(:rails_env, 'staging')} 'p Settings.capistrano.to_hash'"
      # end
      set(:scm_username, ->  { fetch(:app_settings)[:scm_username]} )
      set(:app_path, ->  { fetch(:app_settings)[:path]} )
      set(:user, ->  { fetch(:app_settings)[:user]} )
      set(:puma_ports, ->  { fetch(:app_settings)[:puma_ports]} )
      set(:deploy_to, -> { "#{fetch :app_path}#{fetch :application}"})
    end

    # desc "Set RailsConfig servers"
    task :set_servers do
      puts "TASK:\tserver_config:set_servers  =>  Setting the server...."
      server "#{fetch(:app_settings)[:servers].first}", :app, :web, :db, :primary => true
      fetch(:app_settings)[:servers].slice(1, fetch(:app_settings)[:servers].length-1).each do |host|
        server "#{host}", :app, :web
      end
    end

    desc "See RailsConfig settings"
    task :see do
      puts "TASK:\tserver_config:see  =>  Printing out variables...."
      invoke "server_config:set_variables" unless fetch(:app_settings)
      puts "Variables are set."
      
      # invoke "server_config:set_serves" unless find_servers
      # puts "Servers are set."
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