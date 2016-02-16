require 'capistrano/rails'

# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'paysymmetry'
set :repo_url, 'git@github.com:sinclairtarget/paysymmetry'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/srv/www/app.paysymmetry.com"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('.rbenv-vars')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 
                                               'tmp/pids', 
                                               'tmp/cache', 
                                               'tmp/sockets',
                                               'vendor/bundle',
                                               'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :rbenv_ruby, File.read('.ruby-version').strip

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end
