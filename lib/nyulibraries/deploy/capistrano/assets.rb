Capistrano::Configuration.instance(:must_exist).load do
  before 'deploy:finalize_update', 'deploy:assets:symlink'
  after  'deploy:update_code',     'deploy:assets:precompile'
  
  namespace :deploy do
    namespace :assets do
      desc "Precompiles if assets have been changed"
      task :precompile, :roles => :web, :except => { :no_release => true } do
        from = source.next_revision(current_revision) rescue nil
        if from.nil? || capture("cd #{fetch :current_release} && #{source.local.log(from)[0..-3]} vendor/assets/ lib/assets app/assets/ | wc -l").to_i > 0
          run_locally("rake assets:clean && rake assets:precompile")
          run_locally "cd public && tar -jcf assets.tar.bz2 assets"
          top.upload "public/assets.tar.bz2", "#{fetch :shared_path}", :via => :scp
          run "cd #{fetch :shared_path} && tar -jxf assets.tar.bz2 && rm assets.tar.bz2"
          run_locally "rm public/assets.tar.bz2"
          run_locally("rake assets:clean")
        else
          logger.info "Skipping asset precompilation because there were no asset changes"
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