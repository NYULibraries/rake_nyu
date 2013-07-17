# Including Capistrano Tagging recipes
require 'capistrano/tagging'
Capistrano::Configuration.instance(:must_exist).load do
  before 'tagging:deploy', 'tagging:checkout_branch'
  after 'tagging:deploy', 'tagging:return_to_deploy'
  namespace :tagging do
    task :checkout_branch do
      run "cd #{current_release} && git checkout #{revision}; true" do |channel, stream, data|
        if stream.eql? :err
          run "cd #{current_release} && git checkout -b #{revision}; true"
        end
      end
    end
    
    task :return_to_deploy do
      run "cd #{current_release} && git checkout deploy; true"
    end
  end
  # SSH options
  set :ssh_options, {:forward_agent => true}
  
  # Git vars
  set :scm, :git
  set :deploy_via, :remote_cache
  set(:branch, 'development') unless exists?(:branch)
  set :git_enable_submodules, 1
  
  # Environments
  set :stages, ["staging", "production"]
  set :default_stage, "staging"
  set :keep_releases, 5
  set :use_sudo, false
  
  set(:application) {"#{fetch :app_title}_repos"}
  set(:repository) {"git@github.com:NYULibraries/#{fetch :app_title}.git"}
  
  set :app_dir, '/apps'
end