require 'rubygems'
require 'sidekiq'
require 'sidetiq'

before_fork do |server, worker|
  @sidekiq_pid ||= spawn("bundle exec sidekiq -c 2")
end

worker_processes 2

after_fork do |server, worker|
  Sidekiq.configure_client do |config|
    config.redis = { :size => 1 }
  end
  Sidekiq.configure_server do |config|
    config.redis = { :size => 5 }
    config.poll_interval = 1
  end
end