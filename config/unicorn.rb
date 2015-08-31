rails_root = File.expand_path('../..', __FILE__)
working_directory rails_root

shared_path = File.expand_path('../../../../shared', __FILE__)

pid "#{shared_path}/pids/unicorn.pid"
listen "#{shared_path}/tmp/unicorn.sock"

stderr_path "#{rails_root}/log/unicorn.log"
stdout_path "#{rails_root}/log/unicorn.log"


worker_processes 2
timeout 30

preload_app true
before_fork do |server, worker|
  # This option works in together with preload_app true setting
  # What it does is prevent the master process from holding
  # the database connection
  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  # Here we are establishing the connection after forking worker
  # processes
  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.establish_connection
end
