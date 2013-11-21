require 'bundler'

# Capistrano::Configuration.instance(:must_exist).load do
  # before 'deploy:finalize_update', 'deploy:assets:symlink'
  before 'deploy:updated', 'deploy:assets:symlink'
  
  namespace :deploy do
    namespace :assets do
      def changed_gem_assets gem_name
        gem_revision = capture("cd #{fetch :latest_release} && awk '/#{gem_name}/{getline; print}' Gemfile.lock").to_s.strip!
        capture("cd #{fetch :latest_release} && git diff #{fetch :previous_revision} | grep '#{gem_revision}' | wc -l").to_i
      end
      
      desc "Precompiles if assets have been changed"
      task :precompile do
        on roles( :all, exclude: :no_release ) do |host|
        force_compile = fetch(:force_precompile, false)
        changed_asset_count = 0
        rails_env = "RAILS_ENV=#{fetch(:rails_env, fetch(:stage, fetch(:default_stage, 'staging')))}"
        rails_group = "RAILS_GROUP=assets"
        begin
          from = source.next_revision(current_revision)
          asset_locations = 'app/assets/ lib/assets vendor/assets'
          scm_log = (fetch(:scm, "") == :git) ? "git log #{from}" : source.local.log(from)
          changed_asset_count = capture("cd #{fetch :latest_release} && #{scm_log} #{asset_locations} | wc -l").to_i
          fetch(:assets_gem, []).each do |gem_name|
            changed_asset_count += changed_gem_assets gem_name
          end
        rescue Exception => e
          puts "Error: #{e}, forcing precompile"
          force_compile = true
        end
        if changed_asset_count > 0 || force_compile
          puts "#{changed_asset_count} assets have changed. Pre-compiling"
          run ("cd #{latest_release} && #{rails_env} #{rails_group} bundle exec rake assets:clean")
          run ("cd #{latest_release} && #{rails_env} #{rails_group} bundle exec rake assets:precompile")
        else
          puts "#{changed_asset_count} assets have changed. Skipping asset pre-compilation"
        end
      end
      end

      desc "Creates a symlink for assets"
      task :symlink do
        on roles(:all) do
        run ("rm -rf #{fetch :current_release}/public/assets &&
              mkdir -p #{fetch :current_release}/public &&
              mkdir -p #{fetch :shared_path}/assets &&
              ln -s #{fetch :shared_path}/assets #{fetch :current_release}/public/assets")
            end
      end
    end
  end
# end