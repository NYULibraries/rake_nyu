namespace :nyu do
  namespace :newrelic do
    desc "Set the New Relic file with ERB parsed"
    task :set => :backup  do |task|\
      # Load up the Rails environment
      Rake::Task[:environment].invoke
      RakeNyu::NewRelicManager.rewrite_with_settings
    end

    desc "Backup the New Relic file"
    task :backup do |task|
      RakeNyu::NewRelicManager.backup_original
    end

    desc "Reset the New Relic file"
    task :reset do |task|
      RakeNyu::NewRelicManager.reset_original
    end
  end

  namespace :puma do
    desc "Start the puma web server on the given port"
    task :start, [:port] => :write_scripts do |task, args|
      RakeNyu::PumaManager.start(args[:port])
    end

    desc "Retart the puma web server on the given port"
    task :restart, [:port] => :write_scripts do |task, args|
      RakeNyu::PumaManager.restart(args[:port])
    end

    desc "Stop the puma web server on the given port"
    task :stop, :port do |task, args|
      RakeNyu::PumaManager.stop(args[:port])
    end

    desc "Write the start and restart scripts to files. Does not overwrite if the files exist"
    task :write_scripts, :port do |task, args|
      RakeNyu::PumaManager.write_scripts(args[:port])
    end
  end
end
