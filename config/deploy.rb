require "bundler/capistrano"
require "rvm/capistrano"
set :rvm_ruby_string, '1.9.3-p125@rails.3.2.2'
set :rvm_type, :system

set :application, "csscrop"

# Setup for SCM(Git)
set :scm, :git
set :repository, "git@github.com:rorlab/csscrop.git"
set :branch, "master"

role :web, "cisoh.ncc.re.kr"                          # Your HTTP server, Apache/etc
role :app, "cisoh.ncc.re.kr"                          # This may be the same as your `Web` server
role :db,  "cisoh.ncc.re.kr", :primary => true # This is where Rails migrations will run

set :user, "hyo"
set :deploy_to, "/home/#{user}/sites/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end

# Apache on Ubuntu Server
namespace :apache do
  [:stop, :start, :restart, :reload].each do |action|
    desc "#{action.to_s.capitalize} Apache"
    task action, :roles => :web do
      invoke_command "#{sudo} /etc/init.d/apache2 #{action.to_s}", :via => run_method
    end
  end
end

namespace :logs do
  task :watch do
    stream("cat /home/#{user}/sites/#{application}/current/log/production.log")
  end
end

