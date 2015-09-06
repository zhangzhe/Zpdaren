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
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

before_fork do |server, worker|
  # This option works in together with preload_app true setting
  # What it does is prevent the master process from holding
  # the database connection
  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"

  puts 'pid:'
  puts '-------------------'
  puts server.pid
  puts old_pid
  puts '---------------------'

  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

# 修正无缝重启unicorn后更新的Gem未生效的问题，原因是config/boot.rb会优先从ENV中获取BUNDLE_GEMFILE，
# 而无缝重启时ENV['BUNDLE_GEMFILE']的值并>未被清除，仍指向旧目录的Gemfile
before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "#{rails_root}/Gemfile"
end

after_fork do |server, worker|
  # Here we are establishing the connection after forking worker
  # processes
  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.establish_connection
end

