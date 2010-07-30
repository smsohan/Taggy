# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100722204130) do

  create_table "assignments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "user_story_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attached_files", :force => true do |t|
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "project_id"
    t.integer  "message_id"
    t.integer  "user_story_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instant_messages", :force => true do |t|
    t.text     "content"
    t.integer  "project_id"
    t.string   "application_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source"
    t.string   "identifier"
  end

  create_table "instant_messages_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "instant_message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.integer  "from_user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "from"
    t.string   "to"
    t.string   "cc"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sprint_length",          :default => 14
    t.string   "pop3_server",            :default => "pop.gmail.com"
    t.integer  "pop3_port",              :default => 995
    t.boolean  "pop3_enable_ssl",        :default => true
    t.string   "instant_messenger_name", :default => "Skype"
    t.string   "instant_messenger_user"
  end

  create_table "recipients", :force => true do |t|
    t.integer  "user_id"
    t.integer  "message_id"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relative_weights", :force => true do |t|
    t.float    "date_weight"
    t.float    "people_weight"
    t.float    "subject_weight"
    t.float    "body_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sprints", :force => true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_stories", :force => true do |t|
    t.integer  "project_id"
    t.integer  "sprint_id"
    t.integer  "owner_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  add_index "user_stories", ["description"], :name => "description"
  add_index "user_stories", ["title", "description"], :name => "title_2"
  add_index "user_stories", ["title"], :name => "title"

  create_table "user_story_message_links", :force => true do |t|
    t.integer  "message_id"
    t.integer  "user_story_id"
    t.boolean  "confirmed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "crypted_password",                                 :null => false
    t.string   "password_salt",                                    :null => false
    t.string   "persistence_token",                                :null => false
    t.string   "perishable_token",                                 :null => false
    t.string   "single_access_token",                              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "instant_message_application", :default => "Skype"
    t.string   "instant_message_identity"
    t.string   "instant_messenger_name",      :default => "Skype"
    t.string   "instant_messenger_user"
  end

end
