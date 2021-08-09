---
layout: post
title: "试用Cap3"
date: 2016-02-15 16:42
comments: true
categories: 
---
```
diff --git a/Capfile b/Capfile
new file mode 100644
index 0000000..51c3955
--- /dev/null
+++ b/Capfile
@@ -0,0 +1,29 @@
+# Load DSL and set up stages
+require 'capistrano/setup'
+
+# Include default deployment tasks
+require 'capistrano/deploy'
+
+require 'capistrano/rails'
+
+# Include tasks from other gems included in your Gemfile
+#
+# For documentation on these, see for example:
+#
+#   https://github.com/capistrano/rvm
+#   https://github.com/capistrano/rbenv
+#   https://github.com/capistrano/chruby
+#   https://github.com/capistrano/bundler
+#   https://github.com/capistrano/rails
+#   https://github.com/capistrano/passenger
+#
+# require 'capistrano/rvm'
+# require 'capistrano/rbenv'
+# require 'capistrano/chruby'
+# require 'capistrano/bundler'
+# require 'capistrano/rails/assets'
+# require 'capistrano/rails/migrations'
+# require 'capistrano/passenger'
+
+# Load custom tasks from `lib/capistrano/tasks` if you have any defined
+Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
diff --git a/Gemfile b/Gemfile
index 9786bc1..60dd07d 100644
--- a/Gemfile
+++ b/Gemfile
@@ -10,11 +10,11 @@ gem 'mysql2'
 # Use SCSS for stylesheets
 gem 'sass-rails', '~> 5.0.0.beta1'
 # Use Uglifier as compressor for JavaScript assets
-gem 'uglifier', '>= 1.3.0'
+#gem 'uglifier', '>= 1.3.0'
 # Use CoffeeScript for .js.coffee assets and views
 gem 'coffee-rails', '~> 4.1.0'
 # See https://github.com/sstephenson/execjs#readme for more supported runtimes
-# gem 'therubyracer',  platforms: :ruby
+gem 'therubyracer',  platforms: :ruby
 
 # Use jquery as the JavaScript library
 gem 'jquery-rails'
@@ -46,7 +46,10 @@ gem 'unicorn'
 gem 'thin'
 # Use Capistrano for deployment
 # gem 'capistrano-rails', group: :development
-
+group :development do
+    gem 'capistrano', '~> 3.1'
+    gem 'capistrano-rails', '~> 1.1'
+end
 
 gem 'kaminari', github: 'amatsuda/kaminari', branch: 'master'
 gem 'nokogiri'
diff --git a/config/deploy.rb b/config/deploy.rb
new file mode 100644
index 0000000..7af9419
--- /dev/null
+++ b/config/deploy.rb
@@ -0,0 +1,60 @@
+# config valid only for current version of Capistrano
+lock '3.4.0'
+
+set :application, 'xincheping'
+set :repo_url, 'git@github.com:swachian/xincheping.git'
+
+# Default branch is :master
+# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
+
+# Default deploy_to directory is /var/www/my_app_name
+set :deploy_to, '/opt/deploy/xincheping'
+
+# Default value for :scm is :git
+# set :scm, :git
+
+# Default value for :format is :pretty
+# set :format, :pretty
+
+# Default value for :log_level is :debug
+# set :log_level, :debug
+
+# Default value for :pty is false
+# set :pty, true
+
+# Default value for :linked_files is []
+set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
+
+# Default value for linked_dirs is []
+# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
+ set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets')
+
+# Default value for default_env is {}
+set :default_env, { path: "/home/zhangyu/.rbenv/versions/ruby-2.3/bin:$PATH" }
+
+# Default value for keep_releases is 5
+# set :keep_releases, 5
+
+namespace :deploy do
+
+  after :restart, :clear_cache do
+    on roles(:web), in: :groups, limit: 3, wait: 10 do
+      # Here we can do anything such as:
+      # within release_path do
+      #   execute :rake, 'cache:clear'
+      # end
+    end
+  end
+
+  task :restart_server do
+    on roles(:web) do
+      within current_path do
+        with rails_env: fetch(:rails_env), rails_relative_url_root: '/xincheping' do
+          execute :rake, 'thin:restart', env: {rails_env: fetch(:rails_env) }
+        end
+      end
+    end
+  end
+  after "deploy:published", "restart_server"
+
+end
diff --git a/config/deploy/production.rb b/config/deploy/production.rb
new file mode 100644
index 0000000..a396f40
--- /dev/null
+++ b/config/deploy/production.rb
@@ -0,0 +1,61 @@
+# server-based syntax
+# ======================
+# Defines a single server with a list of roles and multiple properties.
+# You can define all roles on a single server, or split them:
+
+# server 'example.com', user: 'deploy', roles: %w{app db web}, my_property: :my_value
+# server 'example.com', user: 'deploy', roles: %w{app web}, other_property: :other_value
+# server 'db.example.com', user: 'deploy', roles: %w{db}
+
+
+
+# role-based syntax
+# ==================
+
+# Defines a role with one or multiple servers. The primary server in each
+# group is considered to be the first unless any  hosts have the primary
+# property set. Specify the username and a domain or IP for the server.
+# Don't use `:all`, it's a meta role.
+
+role :app, %w{zhangyu@192.168.203.198}, my_property: :my_value
+role :web, %w{zhangyu@192.168.203.198}, other_property: :other_value
+role :db,  %w{zhangyu@192.168.203.198}
+
+
+
+# Configuration
+# =============
+# You can set any configuration variable like in config/deploy.rb
+# These variables are then only loaded and set in this stage.
+# For available Capistrano configuration variables see the documentation page.
+# http://capistranorb.com/documentation/getting-started/configuration/
+# Feel free to add new variables to customise your setup.
+
+
+
+# Custom SSH Options
+# ==================
+# You may pass any option but keep in mind that net/ssh understands a
+# limited set of options, consult the Net::SSH documentation.
+# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
+#
+# Global options
+# --------------
+#  set :ssh_options, {
+#    keys: %w(/home/rlisowski/.ssh/id_rsa),
+#    forward_agent: false,
+#    auth_methods: %w(password)
+#  }
+#
+# The server-based syntax can be used to override options:
+# ------------------------------------
+# server 'example.com',
+#   user: 'user_name',
+#   roles: %w{web app},
+#   ssh_options: {
+#     user: 'user_name', # overrides user setting above
+#     keys: %w(/home/user_name/.ssh/id_rsa),
+#     forward_agent: false,
+#     auth_methods: %w(publickey password)
+#     # password: 'please use keys'
+#   }
diff --git a/config/deploy/staging.rb b/config/deploy/staging.rb
new file mode 100644
index 0000000..4fc06fa
--- /dev/null
+++ b/config/deploy/staging.rb
@@ -0,0 +1,61 @@
+# server-based syntax
+# ======================
+# Defines a single server with a list of roles and multiple properties.
+# You can define all roles on a single server, or split them:
+
+# server 'example.com', user: 'deploy', roles: %w{app db web}, my_property: :my_value
+# server 'example.com', user: 'deploy', roles: %w{app web}, other_property: :other_value
+# server 'db.example.com', user: 'deploy', roles: %w{db}
+
+
+
+# role-based syntax
+# ==================
+
+# Defines a role with one or multiple servers. The primary server in each
+# group is considered to be the first unless any  hosts have the primary
+# property set. Specify the username and a domain or IP for the server.
+# Don't use `:all`, it's a meta role.
+
+# role :app, %w{deploy@example.com}, my_property: :my_value
+# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
+# role :db,  %w{deploy@example.com}
+
+
+
+# Configuration
+# =============
+# You can set any configuration variable like in config/deploy.rb
+# These variables are then only loaded and set in this stage.
+# For available Capistrano configuration variables see the documentation page.
+# http://capistranorb.com/documentation/getting-started/configuration/
+# Feel free to add new variables to customise your setup.
+
+
+
+# Custom SSH Options
+# ==================
+# You may pass any option but keep in mind that net/ssh understands a
+# limited set of options, consult the Net::SSH documentation.
+# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
+#
+# Global options
+# --------------
+#  set :ssh_options, {
+#    keys: %w(/home/rlisowski/.ssh/id_rsa),
+#    forward_agent: false,
+#    auth_methods: %w(password)
+#  }
+#
+# The server-based syntax can be used to override options:
+# ------------------------------------
+# server 'example.com',
+#   user: 'user_name',
+#   roles: %w{web app},
+#   ssh_options: {
+#     user: 'user_name', # overrides user setting above
+#     keys: %w(/home/user_name/.ssh/id_rsa),
+#     forward_agent: false,
+#     auth_methods: %w(publickey password)
+#     # password: 'please use keys'
+#   }
diff --git a/config/environments/production.rb b/config/environments/production.rb
index f572341..cd0d766 100644
--- a/config/environments/production.rb
+++ b/config/environments/production.rb
@@ -19,7 +19,7 @@ Rails.application.configure do
   config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
 
   # Compress JavaScripts and CSS.
-  config.assets.js_compressor = :uglifier
+  #config.assets.js_compressor = :uglifier
   # config.assets.css_compressor = :sass
 
   # Do not fallback to assets pipeline if a precompiled asset is missed.
 
diff --git a/lib/tasks/sync.rake b/lib/tasks/sync.rake
index 6d371d6..bd87ca3 100644
--- a/lib/tasks/sync.rake
+++ b/lib/tasks/sync.rake
@@ -1,10 +1,10 @@
 namespace :sync do
-  desc "TODO"
+  desc "长测新车评同步"
   task changce: :environment do
     Changce.fetch
   end
 
-  desc "TODO"
+  desc "新车评内容全部同步"
   task all: :environment do
     Daogoulist.all.each {|dgl| dgl.sync_daogous(2)}
     Guandian.fetch
@@ -12,4 +12,8 @@ namespace :sync do
     Changce.fetch_changceing
   end
 
+  desc "同sh.122.gov.cn同步电子警察信息"
+  task police2: :environment do
+    ElectronicPoloce2.test_fetch_one_page
+  end
 end
diff --git a/lib/tasks/thin.rake b/lib/tasks/thin.rake
new file mode 100644
index 0000000..9fa35cd
--- /dev/null
+++ b/lib/tasks/thin.rake
@@ -0,0 +1,8 @@
+namespace :thin do
+  desc "重启thin"
+  task restart: :environment do
+    system " if [ -f tmp/pids/thin.pid ]; then kill `cat tmp/pids/thin.pid` && rm tmp/pids/thin.pid; fi"
+    system  "./bin/thin start --prefix=/xincheping  -p 3001 -P tmp/pids/thin.pid -d"
+  end
+
+end
diff --git a/lib/tasks/unicorn.rake b/lib/tasks/unicorn.rake
new file mode 100644
index 0000000..7df54be
--- /dev/null
+++ b/lib/tasks/unicorn.rake
@@ -0,0 +1,8 @@
+namespace :unicorn do
+  desc "重启unicorn"
+  task restart: :environment do
+    system " if [ -f tmp/pids/unicorn.pid ]; then kill `cat tmp/pids/unicorn.pid`; fi"
+    system  "./bin/unicorn -c unicorn.conf.rb -D"
+  end
+
+end
```
