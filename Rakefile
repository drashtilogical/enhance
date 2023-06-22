# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

# Add your own tasks in files placed in the lib/tasks directory, ending in .rake,
# for example lib/tasks/cleanup.rake.
Dir[Rails.root.join('lib', 'tasks', '*.rake')].each { |file| load file }
