Capistrano::Configuration.instance(:must_exist).load do
  # SSH options
  _cset :ssh_options, {:forward_agent => true}
  
  # Git vars
  _cset :scm, :git
  _cset :deploy_via, :remote_cache
  _cset :branch, 'development'
  _cset :git_enable_submodules, 1
  
  # Environments
  _cset :stages, ["staging", "production"]
  _cset :default_stage, "staging"
  _cset :keep_releases, 5
  _cset :use_sudo, false
  
  # Application specs
  _cset(:application) {"#{fetch :app_title}_repos"}
  _cset(:repository) {"git@github.com:NYULibraries/#{fetch :app_title}.git"}
  _cset :app_dir, '/apps'
  
  # Git Tagging vars
  _cset(:tagging_format, ':rails_env_:release')
  _cset(:tagging_remote, 'origin')
  #_cset(:tagging_environments, %w(production))
  
  # RVM  vars
  _cset :rvm_ruby_string, "ruby-1.9.3-p448"
  _cset :rvm_type, :user
  
  # Rails specific vars
  _cset :normalize_asset_timestamps, false
  
  # Bundler vars
  _cset :bundle_without, [:development, :test]
end