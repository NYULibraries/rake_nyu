namespace :nyu do
  namespace :puma do
    desc "Start the puma web server on the given port"
    task :start, [:port] => :write_scripts do |task, args|
      NyuLibraries::PumaManager.start(args[:port])
    end

    desc "Retart the puma web server on the given port"
    task :restart, [:port] => :write_scripts do |task, args|
      NyuLibraries::PumaManager.restart(args[:port])
    end

    desc "Stop the puma web server on the given port"
    task :stop, :port do |task, args|
      NyuLibraries::PumaManager.stop(args[:port])
    end

    desc "Write the start and restart scripts to files. Does not overwrite if the files exist"
    task :write_scripts, :port do |task, args|
      NyuLibraries::PumaManager.write_scripts(args[:port])
    end
  end
end