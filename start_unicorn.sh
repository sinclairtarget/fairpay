#! /bin/bash

RAILS_ENV=production unicorn -c config/unicorn.rb -D
