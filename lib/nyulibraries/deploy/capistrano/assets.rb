require 'bundler'

Capistrano::Configuration.instance(:must_exist).load do
  before 'deploy:finalize_update', 'deploy:assets:symlink'
  
  namespace :deploy do
    namespace :assets do
      def changed_gem_assets gem_name
        gem_revision = capture("cd #{fetch :latest_release} && awk '/#{gem_name}/{getline; print}' Gemfile.lock").to_s.strip!
        capture("cd #{fetch :latest_release} && git diff #{fetch :previous_revision} | grep '#{gem_revision}' | wc -l").to_i
      end
      
      desc "Precompiles if assets have been changed"
      task :precompile, :roles => :web, :except => { :no_release => true } do
        force_compile = false
        changed_asset_count = 0
        rails_env = "RAILS_ENV=#{fetch(:rails_env, fetch(:stage, fetch(:default_stage, 'staging')))}"
        rails_group = "RAILS_GROUP=assets"
        begin
          from = source.next_revision(current_revision)
          asset_locations = 'app/assets/ lib/assets vendor/assets'
          changed_asset_count = capture("cd #{fetch :latest_release} && #{source.local.log(from)} #{asset_locations} | wc -l").to_i
          fetch(:assets_gem, []).each do |gem_name|
            changed_asset_count += changed_gem_assets gem_name
          end
        rescue Exception => e
          logger.info "Error: #{e}, forcing precompile"
          force_compile = true
        end
        if changed_asset_count > 0 || force_compile
          logger.info "#{changed_asset_count} assets have changed. Pre-compiling"
          run ("cd #{latest_release} && #{rails_env} #{rails_group} bundle exec rake assets:clean")
          run ("cd #{latest_release} && #{rails_env} #{rails_group} bundle exec rake assets:precompile")
        else
          logger.info "#{changed_asset_count} assets have changed. Skipping asset pre-compilation"
        end
      end

      desc "Creates a symlink for assets"
      task :symlink, roles: :web do
        run ("rm -rf #{fetch :current_release}/public/assets &&
              mkdir -p #{fetch :current_release}/public &&
              mkdir -p #{fetch :shared_path}/assets &&
              ln -s #{fetch :shared_path}/assets #{fetch :current_release}/public/assets")
      end
    end
  end
end