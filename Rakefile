# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

GoodGamesServer::Application.load_tasks

task :test_environment do
  ENV['RAILS_ENV'] = 'test'
end

task :spec => [:test_environment]
