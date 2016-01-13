#!/bin/bash

cd /usr/src/app

bundle exec rake db:migrate RAILS_ENV=production

bundle exec sidekiq -e production

service nginx start && bundle exec unicorn_rails -E production -c config/unicorn.rb
