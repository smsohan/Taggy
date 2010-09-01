# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

$:.reject! { |e| e.include? 'TextMate' }

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

require 'rubygems'
gem 'ci_reporter'
require 'ci/reporter/rake/test_unit'


namespace :taggy do
  task :evaluate => [:environment] do
    Rails.logger.level = 3
    project_ids = (ENV['p'] || ENV['projects']).split(',')
    puts "Evaluating Taggy for projects: #{project_ids}"
    projects = Project.find(project_ids)
    offset = ENV['o'] || ENV['offset'] || 0
    offset = offset.to_i
    begin
      Message.evaluate_tagging projects, offset
    rescue Exception => error
      Rails.logger.error "Exception in evaluating"
      Rails.logger.error error.backtrace.join(" ")
      puts error.message
    end
    
    Rails.logger.level = 0
  end  
end

namespace :jazz do
  task :sprint => [:environment] do
    Rails.logger.level = 3
    id =  ENV["id"] || ENV["sprint"]
    sprint = Sprint.find(id)
    puts "Importing sprint work items from Jazz for #{sprint.project.name}: #{sprint.name}"
    Jazz::Importer.new.import_iteration_work_items sprint.project_id, sprint.jazz_id
    puts "Completed importing #{sprint.user_stories.count} user stories"
    Rails.logger.level = 0
  end
end
