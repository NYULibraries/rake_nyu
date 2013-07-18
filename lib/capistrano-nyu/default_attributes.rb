# Including Capistrano Tagging recipes
require 'capistrano/tagging'
Capistrano::Configuration.instance(:must_exist).load do
  before 'tagging:deploy', 'tagging:checkout_branch'
  namespace :tagging do
    task :checkout_branch do
      run "cd #{current_release} && git branch; true" do |channel, stream, data|
        data.gsub!(/\**[^\S\n]+/, "")
        if !data.split("\n").include? "#{revision}"
          run_locally "git checkout -b #{revision}; true"
          run_locally "git checkout deploy; true"
        end
      end
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