web: bundle exec rackup config.ru -p $PORT
worker: mkdir -p log && mkdir -p tmp/pids && bundle exec sidekiq -r ./workers/init.rb
