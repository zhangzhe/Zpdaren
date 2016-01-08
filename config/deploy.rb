# config valid only for current version of Capistrano
lock '3.4.0'

server '182.92.221.174', user: 'deploy', roles: %w{app web db}, my_property: :my_value

set :application, 'Epin'
set :repo_url, 'git@github.com:SparkYacademy/Epin.git'
set :recipient, "Ruby"
set :branch, "develop"
set :default_stage, "production"
# set :pty, false
set :deploy_to, "/data/Epin"
set :use_sudo, false
set :tmp_dir, '/data/Epin/shared/tmp'
# set :rails_env, "production"
# set :unicorn_config_path, "#{current_path}/config/unicorn.rb"
# set :unicorn_rack_env, "#{fetch(:default_stage)}"
set :sidekiq_monit_default_hooks, false
# set :sidekiq_config, "#{current_path}/config/sidekiq.yml"
set :linked_files, fetch(:linked_files, []).push('config/database.yml')
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/sitemaps uploads public/uploads/interview/avatar}

namespace :deploy do
  desc "Start Application"
  task :start do
    invoke 'unicorn:start'
  end

  desc "Restart Application"
  task :restart do
    invoke 'unicorn:restart'
  end


  desc "Stop Application"
  task :stop do
    invoke 'unicorn:stop'
  end
end

# after 'deploy:publishing', 'deploy:start'
after 'deploy:publishing', 'deploy:restart'

