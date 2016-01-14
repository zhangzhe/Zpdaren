#!/bin/bash

cd /usr/src/app

bundle exec rake db:migrate RAILS_ENV=production

echo `service nginx start`

echo `bundle exec unicorn_rails -E production -c config/unicorn.rb -D`

echo `bundle exec sidekiq -e production`
