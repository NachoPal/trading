require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/bundler'
require 'capistrano/rails/migrations'
require 'capistrano/passenger'
#require 'capistrano/scm/git'
#install_plugin Capistrano::SCM::Git

require 'capistrano/rvm'
set :rvm_type, :user
set :rvm_ruby_version, '2.3.1'