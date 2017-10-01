application = 'trading'
aws_server = '54.186.214.132'

set :stage, 'staging'
set :rails_env, 'staging'
set :application, application
set :branch, :staging
set :deploy_to, "/home/deploy/#{application}"

# # # Capistrano rvm
rvm_mri = 'ruby-2.3.1@tr'
set :rvm_ruby_version, rvm_mri
set :rvm_type, :user
set :rvm_install_type, :head
set :rvm_ruby_string_evaluated, 'release_path'

server aws_server, user: 'deploy', roles: %w{app web db}
