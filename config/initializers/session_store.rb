# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_emailable_session',
  :secret      => 'ef1a3b22d2c290c73f0ed5eaf1ffc780f4760dcf2c9659ea4bcae823c7f27aa553e0594bfa65f2d4f0f8921889e124299da94d3a10523e17f45d089a3994d981'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
