# config valid only for current version of Capistrano
lock '3.4.0'

server '182.92.221.174', user: 'deploy', roles: %w{app web db}, my_property: :my_value

set :application, 'Epin'
set :repo_url, 'git@github.com:SparkYacademy/Epin.git'
set :recipient, "Ruby"
set :branch, "develop"
set :default_stage, "production"
set :pty, false
set :deploy_to, "/data/Epin"
set :use_sudo, false
set :tmp_dir, '/data/Epin/shared/tmp'
set :rails_env, "production"
set :sidekiq_config, "#{fetch(:deploy_to)}/current/config/sidekiq.yml"
set :linked_files, fetch(:linked_files, []).push('config/database.yml')
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/sitemaps uploads public/uploads/interview/avatar}

# after 'deploy:publishing', 'deploy:start'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

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

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  desc "Start Application"
  task :start do
    on roles(:app) do
      within release_path do
        execute :bundle, :exec, "unicorn_rails -E production -c config/unicorn.rb  -D"
      end
      # execute "cd #{fetch(:deploy_to)}/current && bundle exec unicorn_rails -E production -c config/unicorn.rb  -D"
    end
  end

  desc "Stop Application"
  task :stop do
    on roles(:app) do
      execute "kill -QUIT `cat #{fetch(:deploy_to)}/shared/pids/unicorn.pid`"
    end
  end

  desc "Restart Application"
  task :restart do
    on roles(:app) do
      execute "kill -USR2 `cat #{fetch(:deploy_to)}/shared/pids/unicorn.pid`"
    end
  end

  after :publishing, :restart

  # %w[start stop restart].each do |command|
  #   desc "#{command} unicorn server"
  #   task command do
  #     on roles(:app) do
  #       execute "service raffler #{command}"
  #     end
  #   end
  # end

  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, 'cache:clear'
  #     # end
  #   end
  # end
  # after "deploy", "deploy:migrate"

end
