task :production do
  set :rails_env,   "production"
  set :application, "taggy"
  set :deploy_to,   "/taggy"
  set :use_sudo,    false
  set :scm_verbose, true
  set :user,        "ubuntu"
  set :domain,      "ec2-204-236-140-199.us-west-1.compute.amazonaws.com"
  set :scm,         :git
  set :branch,      "master"
  set :repository,  "git://github.com/smsohan/Taggy.git"
  set :deploy_via,  :remote_cache  
  ssh_options[:keys] = %w(~/.ssh/id_amazon)
  
  server             domain, :app, :web
  role               :db, domain, :primary => true
end

namespace :passenger do
  desc "Restart the Passenger instance."
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
  
namespace :crontab do
  desc "Update the application crontab file."
  task :update, :roles => :db do
    run "cd #{release_path} && whenever --update-crontab #{application}"
  end
end

namespace :solr do
  desc "stop and start solr server."
  task :restart, :roles => :app do
    run "cd #{release_path} && sudo rake solr:stop RAILS_ENV=#{rails_env} && sudo rake solr:start RAILS_ENV=#{rails_env}"
  end
end

namespace :gems do
  desc "install gems."
  task :install, :roles => :app do
    run "cd #{release_path} && sudo rake gems:install"
  end
end



namespace :deploy do
  
  before "deploy", "deploy:cleanup"
  %w(start restart).each { |name| task name do passenger.restart end }
  after "deploy:update_code", "deploy:symlink_shared_files_and_dirs"
  after "deploy:symlink_shared_files_and_dirs", "solr:restart"
  after "solr:restart", "crontab:update"
  
  desc "Symlink shared files and directories."
  task :symlink_shared_files_and_dirs do
    run "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

end