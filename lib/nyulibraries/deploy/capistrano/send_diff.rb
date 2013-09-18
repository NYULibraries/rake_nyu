require 'git'
require 'octokit'
require 'mail'

Capistrano::Configuration.instance(:must_exist).load do
  after   "deploy", "send_diff:send_diff"
  namespace :send_diff do
    
    def repo_name
      @repo_name ||= "#{fetch(:repository).scan(/:(.*)\.git/).last.first}"
    end
    
    def git_tags
      git = Git.open(Dir.pwd.to_s)
      git.fetch
      tags = Array.new
      git.tags.each {|tag| tags.push tag}
      tags
    end
    
    def tags_exist?
      current_tag = fetch(:current_tag,"")
      previous_tag = fetch(:previous_tag,"")
      if previous_tag.empty? || current_tag.empty?
        return false
      end
      tags = git_tags
      tags.keep_if do |tag|
        tag.name.eql?(current_tag) || tag.name.eql?(previous_tag)
      end
      return tags.count > 1
    end
    
    def git_compare
      if tags_exist?
        short_link = git_io "https://www.github.com/#{repo_name}/compare/#{fetch :previous_tag}...#{fetch :current_tag}"
        return "Something has changed in #{fetch(:app_title, 'this project')}!\n Check out this sick compare: #{short_link}"
      end
      return "There was a redeployment in #{fetch(:app_title)}, but no release tags to compare!\n Current relase: #{fetch :current_tag,'uknown'}"
    end
    
    def git_io link
      run "curl -i http://git.io -F \"url=#{link}\"" do |channel, stream, data|
        if data.include? "Location:"
          return data.scan(/Location:\s+(.*)/).last.first
        end
      end 
    end
    
    def set_diff
      set :git_diff, git_compare
    end
    
    def mail_setup
      Mail.defaults do
        delivery_method :smtp, { 
          :openssl_verify_mode => OpenSSL::SSL::VERIFY_NONE, 
          :address => 'mail.library.nyu.edu',
          :port => '25',
          :enable_starttls_auto => true
        }
      end
    end
    
    desc "Sends git diff"
    task :send_diff do
      mail_setup
      set_diff
      
      mail = Mail.new
      mail[:from]     = 'no-reply@library.nyu.edu'
      mail[:body]     = fetch(:git_diff)
      mail[:subject]  = "Recent changes for #{fetch(:app_title, 'this project')}"
      mail[:to]       = fetch(:recipient, "")

      mail.deliver! unless mail[:to].to_s.empty?
      logger.info mail[:to].to_s.empty? ? "Diff not sent, recipient not found. Be sure to `set :recipient, 'you@host.tld'`" : "Diff sent to #{mail[:to]}"
    end
  end
end