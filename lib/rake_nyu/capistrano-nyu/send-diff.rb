require 'capistrano'
require 'git'
require 'octokit'
require 'mail'

Capistrano::Configuration.instance(:must_exist).load do
  after   "deploy",           "diff:send_diff"
  before  "diff:send_diff",   "diff:mail_setup"
  before  "diff:mail_setup",  "diff:get_diff"
  
  namespace :diff do
    desc "Prints out git diff"
    task :get_diff do
      begin
        set :git_diff, Octokit.commits("#{fetch :repository}".scan(/:(.?*).git/).last.first, "#{fetch :branch}").first.html_url
      rescue
        git = Git.open(Dir.pwd.to_s)
        commits = Array.new
        git.log.each {|l| commits.push l.sha }
        set :git_diff, git.diff(commits.first(2).last, commits.first(2).first).to_s
      end
    end
      
    task :send_diff do
      body_message = fetch :git_diff
      mail = Mail.new do
        from    'capistrano@library.nyu.edu'
        body    body_message
      end
      mail[:subject] = "Recent changes for #{fetch(:app_title, 'this project')}"
      mail[:to] = fetch :recipient, ""
      mail.deliver! unless mail[:to].to_s.empty?
    end
    
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