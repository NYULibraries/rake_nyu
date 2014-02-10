Capistrano::Configuration.instance(:must_exist).load do
  # Set the servers from rails config before we see
  # what's in the rails config environment
  before  "deploy",                             "rails_config:see"
  before  "deploy:cold",                        "rails_config:see"
  before  "deploy:setup",                       "rails_config:see"
  before  "deploy:check",                       "rails_config:see"
  before  "deploy:assets:update_asset_mtimes",  "rails_config:see"
  
  namespace :rails_config do
    # desc "Set stage variables"
    task :set_variables do
      # Configure app_settings from rails_config
      # Defer processing until we have rails environment
      set(:app_settings, true)
      set(:scm_username, ENV['LOGIN_SCM_USERNAME'])
      set(:app_path, ENV['LOGIN_APP_PATH'])
      set(:user,ENV['LOGIN_USER'])
      
    end

    # desc "Set RailsConfig servers"
    task :set_servers do
      server ENV['LOGIN_PRIMARY_SERVER'], :app, :web, :db, :primary => true
    end

    desc "See RailsConfig settings"
    task :see do
      if !exists?(:app_settings)
        set_variables
        set_servers
        p "Variables now set."
      else
        p "Variables already set."
      end
      # p "Settings: #{fetch :app_settings}"
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