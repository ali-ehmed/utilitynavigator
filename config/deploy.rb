# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'utility_navigator'
set :repo_url, 'git@bitbucket.org:aliahmed922/utility_navigator.git'
# set :ssh_options, { forward_agent: true, paranoid: true, keys: "~/.ssh/work_rsa" }
# load "lib/channel_list_ordered.xlsx"
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deploy/utility_navigator'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

set :linked_files, %w{config/database.yml config/secrets.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :keep_assets, 2

# Add this to the settings section at the top:
set :ping_url, "https://www.utilitynaigators.com/ping"
set :pty, true
# set :use_sudo, false

namespace :deploy do
	desc 'Runs rake db:seed'
	task :seed => [:set_rails_env] do
	  on primary fetch(:migration_role) do
	    within release_path do
	      with rails_env: fetch(:rails_env) do
	        execute :rake, "db:seed"
	      end
	    end
	  end
	end

	desc 'Runs rake db:setup'
	task :setup => [:set_rails_env] do
	  on primary fetch(:migration_role) do
	    within release_path do
	      with rails_env: fetch(:rails_env) do
	        execute :rake, "db:setup"
	      end
	    end
	  end
	end

	# This is the standard Phusion Passenger restart code. You will probably already
	# have something like this (if you have already got Capistrano set up).

	task :start do ; end
  task :stop do ; end
  task :restart do
    # run "#{sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
    on roles(:app), in: :sequence do
       execute! :sudo, "touch #{File.join(current_path,'tmp','restart.txt')}"
       execute! :sudo, :service, :nginx, :restart
    end
  end

  task :ping do
    system "curl --silent #{fetch(:ping_url)}"
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end

# Add this to automatically ping the server after a restart:
after "deploy:restart", "deploy:ping"
after :deploy, "deploy:restart"
