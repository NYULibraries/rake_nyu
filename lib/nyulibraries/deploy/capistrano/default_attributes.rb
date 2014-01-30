# Capistrano::Configuration.instance(:must_exist).load do
  # Hack on Capistrano, Capistrnao requires :repository to be set, and thus is always set with garbage value.
  # This makes it impossible to detect wether or not the user set it, so deleteting here solves that.
  # Also, we re-set it here anyway, so it's safe thus far...
  delete :repository
  delete :application
  
  # SSH options
  set :ssh_options, {:forward_agent => true}
  
  # Git vars
  set :scm, :git
  set :deploy_via, :remote_cache
  set :branch, 'development'
  set :git_enable_submodules, 1
  
  # Environments
  set :stages, ["staging", "production"]
  set :default_stage, "staging"
  set (:keep_releases, -> {fetch(:stage,"").eql?("production") ? 5 : 1})
  set :use_sudo, false
  
  # Application specs
  set(:application, -> {"#{fetch :app_title}_repos"})
  set(:repository, -> {"git@github.com:NYULibraries/#{fetch :app_title}.git"})
  
  # Git Tagging vars
  set(:current_tag, -> {"#{fetch :stage}_#{release_path.to_s.gsub(releases_path.to_s+'/','')}"})
  set(:previous_tag, -> {
      invoke "deploy:last_release_path"
      "#{fetch :stage}_#{release_path.to_s.gsub(releases_path.to_s+'/','')}"
    })
  set :tagging_remote, 'origin'
  set :tagging_environments, ["production"]
  
  # RVM  vars
  set :rvm_ruby_string, "ruby-1.9.3-p448"
  set :rvm_type, :user
  
  # Rails specific vars
  set :normalize_asset_timestamps, false
  
  # New Relic vars
  set :new_relic_environments, ["production"]
  
  # Bundler vars
  # set :bundle_without, [:development, :test]
  # set :bundle_cleaning_environments, ["staging", "development"]
  set :bundle_gemfile, -> { release_path.join('Gemfile') }
  set :bundle_dir, -> { shared_path.join('bundle') }
  set :bundle_flags, '--deployment'
  set :bundle_without, %w{development test}.join(' ')
  set :bundle_binstubs, -> { shared_path.join('bin') }
  set :bundle_roles, :all
  
  # Precompile vars
  set :assets_gem, ["nyulibraries-assets.git", "nyulibraries_assets.git"]
  set :force_precompile, false
  set :ignore_precompile, false
