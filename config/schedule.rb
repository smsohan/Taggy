set :path, '/taggy/current' 

every 1.minute do
  runner "Project.grab_all_emails!"
end