Capistrano::Configuration.instance(:must_exist).load do
  after "deploy", "deploy:cleanup", "cache:tmp_clear"
  
  namespace :cache do
    desc "Clear rails cache"
    task :tmp_clear, :roles => :app do
      run "cd #{current_release} && RAILS_ENV=#{fetch :rails_env} bundle exec rake tmp:clear"
    end
  end
end