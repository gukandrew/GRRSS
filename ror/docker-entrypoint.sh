#!/bin/bash

# Prepare db and crontab
bin/rails db:prepare
bin/bundle exec whenever --update-crontab -s environment=development
crond

# Precompile assets
rails assets:precompile

rm tmp/pids/server.pid

# Start rss consumer and rails server in parallel
bin/rails runner "RssConsumer.new.start" &
bin/bundle exec rails s -p 3000 -b 0.0.0.0 -e development

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?
