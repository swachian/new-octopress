threads 8, 32
workers 2
#preload_app! # go all in the master process and the master process won't be workers any more

#rackup DefaultRackup
port        ENV['PORT']     || 4000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  #   # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  # ActiveRecord::Base.establish_connection
end
