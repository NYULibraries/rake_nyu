namespace :nyu do
  namespace :newrelic do
      # If we're in the Rails environment, use Rails initializers
      if defined?(::Rails) && ::Rails.version >= '3.1.0'
        Rake::Task[:environment].invoke
      elsif (not args[:config_file].empty?)
        Rake::Task['exlibris:aleph:initialize_via_config_file'].invoke(args[:config_file])
      elsif (not args[:tab_path].empty?) and (not args[:adms].empty?)
        Rake::Task['exlibris:aleph:initialize_via_args'].invoke(args[:tab_path],  args[:yml_path], args[:adms])
      else
        raise Rake::TaskArgumentError.new("Insufficient arguments.")
      end
      p "Configured tab path: #{Exlibris::Aleph::TabHelper.tab_path}"
      p "Configured yml path: #{Exlibris::Aleph::TabHelper.yml_path}"
      p "Configured ADMs: #{Exlibris::Aleph::TabHelper.adms}"
    end
  end
  namespace :puma do
    desc "Start the puma web server on the given port."
    task :start, :port, :shared_path do |task, args|
      port = args[:port]
      shared_path = args[:shared_path]
    end

    desc "Retart the puma web server on the given port."
    task :restart, :port, :shared_path do |task, args|
      port = args[:port]
      shared_path = args[:shared_path]
    end

    desc "Stop the puma web server on the given port."
    task :stop, :port, :shared_path do |task, args|
      port = args[:port]
      shared_path = args[:shared_path]
    end
  end
end