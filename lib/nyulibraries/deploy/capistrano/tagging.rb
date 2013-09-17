require 'capistrano'

Capistrano::Configuration.instance(:must_exist).load do
  after  'deploy:restart', 'tagging:deploy'
  before 'tagging:deploy', 'tagging:checkout_branch'

  namespace :tagging do

    def remote
      fetch(:tagging_remote)
    end

    def tagging_environment?
      return true if fetch(:tagging_environments).nil?
      fetch(:tagging_environments).collect {|environment| environment.to_sym}.include?(fetch(:stage, fetch(:rails_env, :staging)).to_sym)
    end

    def user_name
      `git config --get user.name`.chomp
    end

    def user_email
      `git config --get user.email`.chomp
    end

    def create_tag
      if tagging_environment?
        run_locally "git tag #{fetch :current_tag} #{revision} -m \"Deployed by #{user_name} <#{user_email}>\""
        run_locally "git push #{remote} refs/tags/#{fetch :current_tag}:refs/tags/#{fetch :current_tag}"
      else
        logger.info "ignored git tagging in #{fetch(:rails_env, fetch(:stage, 'staging'))} environment"
      end
    end

    desc "Make sure branch is checked out and up to date before tagging"
    task :checkout_branch do
      run_locally "git checkout -b #{revision}; true"
      run_locally "git checkout .; true"
      run_locally "git checkout #{revision}; true"
      run_locally "git pull origin #{revision}; true"
    end
    
    desc "Create release tag in local and origin repo"
    task :deploy do
      create_tag
    end
  end
end
