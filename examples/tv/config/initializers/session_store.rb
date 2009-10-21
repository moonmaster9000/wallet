# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_tv_session',
  :secret      => '91c1045d111179c9c4f12bea2f0539bd547c4e313f9ac11d0b737b60257666d0be6aea4542e620bc51d55635e98d2e1b2c46bdb308ffe3b73fd8fe8d59a811bc'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
