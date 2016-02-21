# Config file for Unicorn application server
#
# set path to application
app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"
working_directory app_dir

# set unicorn options
worker_processes 2
timeout 30

# load application into master before fork for speediness
# if the application opens any sockets or files those will be shared by the
# worker children. Those sockets/files should be closed and reopened in the
# worker children. SEE BELOW
preload_app true 

# set up socket location
listen "#{shared_dir}/sockets/unicorn.sock", :backlog => 64

# set up logs
stderr_path "#{shared_dir}/log/unicorn.stderr.log"
stdout_path "#{shared_dir}/log/unicorn.stdout.log"

# set location for pid file
pid "#{shared_dir}/pids/unicorn.pid"

before_fork do |server, worker|
  # make sure the master process never holds a database socket connection
  # it never needs one -- we don't want to mess with child process connections
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  # when unicorn is restarted using the USR2 signal, it starts up a new master
  # process but continues serving requests. The pid for the old master process
  # is unicorn.pid.oldbin. We need to kill the old process if it exists
  # https://unicorn.bogomips.org/SIGNALS.html
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  # restablish the database connection we killed above
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
