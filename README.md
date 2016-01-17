# fairpay
A secret project.

## Running Locally
1. Make sure you have `gem` installed. `gem` is a package manager for Ruby. If it's not already on your computer,
you can get it [here](https://rubygems.org/pages/download). An alternative is to install Ruby via [Homebrew](http://brew.sh/).
2. Make sure you have Bundler (`bundle`) installed. You can install Bundler via `gem`:
        
        $ gem install bundler
3. Run `bundle install` in the root folder of the project. This will install all the gems the project depends on.
4. Ensure that you've installed MySQL and have the daemon process running. Then enter:
        
        $ rake db:create db:migrate
This will set up a local database for the app to use.

5. To start the server, run:
        
        $ bundle exec rails server
