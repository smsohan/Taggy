set :path, '/Users/smsohan/Taggy' 
# set :environment, :development

every 1.minute do
  runner "Project.grab_all_emails!"
end