require "bundler/capistrano"
require "rvm/capistrano"

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

server "localhost", :web, :app, :db, primary: true

set :application, "wrektranet"
set :user, "deploy"
set :port, 22
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:wrekatlanta/wrektranet.git"
set :branch, "master"


default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :cold do
    transaction do
      update
      setup_db  #replacing migrate in original
      start
    end
  end

  task :setup_db, roles: :app do
    raise RuntimeError.new('db:setup aborted!') unless Capistrano::CLI.ui.ask("About to `rake db:setup`. Are you sure to wipe the entire database (anything other than 'yes' aborts):") == 'yes'
    run "cd #{current_path}; bundle exec rake db:setup RAILS_ENV=#{rails_env}"
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    put File.read("config/application.example.yml"), "#{shared_path}/config/application.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :update_config do
    put File.read("config/database.yml"), "#{shared_path}/config/database.yml"
    put File.read("config/application.yml"), "#{shared_path}/config/application.yml"
    put File.read("config/ldap.yml"), "#{shared_path}/config/ldap.yml"
  end

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/application.yml #{release_path}/config/application.yml"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/ldap.yml #{release_path}/config/ldap.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end

  before "deploy", "deploy:check_revision"

  namespace :rails do
    desc "Remote console"
    task :console, roles: :app do
      run_interactively "bundle exec rails console #{rails_env}"
    end
  end

  namespace :db do
    desc "Remote console"
    task :rollback, roles: :app do
      run_interactively "bundle exec rake db:rollback"
    end
  end

  def run_interactively(command, server=nil)
    server ||= find_servers_for_task(current_task).first
    exec %Q(ssh #{user}@#{server.host} -t 'sudo su - #{user} -c "cd #{current_path} && #{command}"')
  end
end
