module RakeNyu
  class PumaConfig
    attr_reader :port

    def initialize(*args)
      @port = args.shift
    end

    def scripts_path
      @scripts_path ||= "#{Rails.root}/config/deploy/puma"
    end

    def pid
      @pid ||= "#{Rails.root}/tmp/pids/puma-#{port}.pid"
    end

    def log
      @log ||= "#{Rails.root}/log/puma-#{Rails.env}-#{port}.log"
    end

    def bind
      @bind ||= "tcp://127.0.0.1:#{port}"
    end

    def start_file
      @start_file ||= "#{scripts_path}/start-#{port}.sh"
    end

    def restart_file
      @restart_file ||= "#{scripts_path}/restart-#{port}.sh"
    end

    # Start command
    def start_cmd
      @start_cmd ||= "cd #{Rails.root} && RAILS_ENV=#{Rails.env} bundle exec #{start_file} && echo 'Starting' >> #{log}"
    end

    # Stop command
    def stop_cmd
      @stop_cmd ||= "kill -9 \\`cat #{pid}\\` && rm -rf #{pid} && echo 'Stopping..' >> #{log}"
    end

    # Restart command
    def restart_cmd
      @restart_cmd ||= "cd #{Rails.root} && RAILS_ENV=#{Rails.env} bundle exec #{restart_file}"
    end

    # Start script code
    def start_script
      @start_script ||= %Q(
        #!/bin/bash
        puma -b #{bind} -e #{Rails.env} -t 2:4 --pidfile #{pid} >> #{log} 2>&1 &
        exit
      ).strip
    end

    # Restart script code
    def restart_script
      @restart_script ||= %Q(
        #!/bin/bash
        if [ -a #{pid} ]; then
          #{stop_cmd}
        fi
        #{start_cmd}
        exit
      ).strip
    end
  end
end