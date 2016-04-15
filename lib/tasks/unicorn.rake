namespace :unicorn do
  desc "Starts the unicorn application server in production."
  task :start do
    sh %{ RAILS_ENV=production unicorn -c config/unicorn.rb -D }
  end

  desc "Stops the unicorn application server."
  task :stop do
    sh %{ kill -QUIT $(cat shared/pids/unicorn.pid) }
  end

  namespace :development do
    desc "Starts the unicorn application server in development."
    task :start do
      sh %{ unicorn -c config/unicorn.rb -D }
    end
  end
end
