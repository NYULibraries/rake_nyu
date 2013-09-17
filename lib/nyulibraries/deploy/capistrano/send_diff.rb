require 'git'
require 'octokit'
require 'mail'

Capistrano::Configuration.instance(:must_exist).load do
  after   "deploy", "send_diff:send_diff"
  
  namespace :send_diff do
    def public_repo
      repo_name = "#{fetch(:repository).scan(/:(.*)\.git/).last.first}"
      tags = Octokit.tags(repo_name)

      if tags.count > 1
        to = tags.first
        from = exists?(:previous_tag) ? (tags.keep_if{|tag| tag.name.eql?(fetch(:previous_tag))}).first : tags[1]
        return git_io "https://www.github.com/#{repo_name}/compare/#{from.commit.sha}...#{to.commit.sha}"
      end
    end
    
    def git_io link
      run "curl -i http://git.io -F \"url=#{link}\"" do |channel, stream, data|
        if data.include? "Location:"
          return data.scan(/Location:\s+(.*)/).last.first
        end
      end 
    end
    
    def private_repo
      git = Git.open(Dir.pwd.to_s)
      commits = Array.new
      git.log.each {|l| commits.push l.sha }
      git.diff(commits.first(2).last, commits.first(2).first).to_s
    end
    
    def set_diff
      begin
        set :git_diff, public_repo
      rescue
        set :git_diff, private_repo
      end
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
      mail[:body]     = fetch(:git_diff, "No changes in #{fetch(:app_title, 'this project')}")
      mail[:subject]  = "Recent changes for #{fetch(:app_title, 'this project')}"
      mail[:to]       = fetch(:recipient, "")

      mail.deliver! unless mail[:to].to_s.empty?
      logger.info mail[:to].to_s.empty? ? "Diff not sent, recipient not found. Be sure to `set :recipient, 'you@host.tld'`" : "Diff sent to #{mail[:to]}"
    end
  end
end