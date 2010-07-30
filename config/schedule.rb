set :path, '/Users/smsohan/thesis/emailable' 
set :environment, :development

every 1.minute do
  runner "Project.grab_all_emails!"
end