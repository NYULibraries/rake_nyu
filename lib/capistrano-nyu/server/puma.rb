require 'capistrano'

Capistrano::Configuration.instance(:must_exist).load do
  namespace :deploy do
      
    desc "Start the application"
    task :start do
      puma_ports.each do |port|
        run "cd #{current_release} && RAILS_ENV=#{fetch :rails_env, 'staging'} bundle exec rake nyu:puma:start[#{fetch :port, '9000'}]"
      end
    end
  
    desc "Stop the application"
    task :stop do
      puma_ports.each do |port|
        run "cd #{current_release} && RAILS_ENV=#{fetch :rails_env, 'staging'} bundle exec rake nyu:puma:stop[#{fetch :port, '9000'}]"
      end
    end
  
    desc "Restart the application"
    task :restart, :roles => :app, :except => { :no_release => true } do
      puma_ports.each do |port|
        run "cd #{current_release} && RAILS_ENV=#{fetch :rails_env, 'staging'} bundle exec rake nyu:puma:restart[#{fetch :port, '9000'}]"
      end
    end
  end
end