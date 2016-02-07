# Config file for Unicorn application server
#
# set path to application
app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"
working_directory app_dir

# set unicorn options
worker_processes 2
preload_app true
timeout 30

# set up socket location
listen "#{shared_dir}/sockets/unicorn.sock", :backlog => 64

# set up logs
stderr_path "#{shared_dir}/log/unicorn.stderr.log"
stdout_path "#{shared_dir}/log/unicorn.stdout.log"

# set location for pid file
pid "#{shared_dir}/pids/unicorn.pid"
