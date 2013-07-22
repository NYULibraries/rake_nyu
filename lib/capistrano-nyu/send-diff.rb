require 'git'
require 'octokit'
require 'mail'

Capistrano::Configuration.instance(:must_exist).load do
  after   "deploy",               "send_diff:send_diff"
  before  "send_diff:send_diff",       "send_diff:mail_setup"
  before  "send_diff:mail_setup", "send_diff:get_diff"
  
  namespace :send_diff do
    
    def public_repo
      repo_name = "#{fetch(:repository).scan(/:(.*)\.git/).last.first}"
      tags = Octokit.tags(repo_name)
      if tags.count > 1
        to = tags.first
        from = tags[1]
        git_link = "https://www.github.com/#{repo_name}/compare/#{from.commit.sha}...#{to.commit.sha}"
        run "curl -i http://git.io -F \"url=#{git_link}\"" do |channel, stream, data|
          if data.include? "Location:"
            data.scan(/Location:\s+(.*)/).last.first
          end
        end
      end
    end
    
    def private_repo
      git = Git.open(Dir.pwd.to_s)
      commits = Array.new
      git.log.each {|l| commits.push l.sha }
      git.diff(commits.first(2).last, commits.first(2).first).to_s
    end
    
    desc "Gets git diff"
    task :get_diff do
      begin
        set :git_diff, public_repo
      rescue
        set :git_diff, private_repo
      end
    end
    
    desc "Sends git diff"
    task :send_diff do
      body_message = fetch(:git_diff, "No changes in #{fetch(:app_title, 'this project')}")
      mail = Mail.new do
        from    'no-reply@library.nyu.edu'
        body    body_message
      end
      mail[:subject] = "Recent changes for #{fetch(:app_title, 'this project')}"
      mail[:to] = fetch :recipient, ""
      mail.deliver! unless mail[:to].to_s.empty?
    end
    
    desc "Sets up settings for mail"
    task :mail_setup do
      Mail.defaults do
        delivery_method :smtp, { 
          :openssl_verify_mode => OpenSSL::SSL::VERIFY_NONE, 
          :address => 'mail.library.nyu.edu',
          :port => '25',
          :enable_starttls_auto => true
        }
      end
    end
  end
end