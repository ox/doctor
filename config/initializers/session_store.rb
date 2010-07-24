# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_Doctor_session',
  :secret      => '66215f5aa379e7c8794cea265c5cc61607e34f4549aa6c25a2417384bfe5cd4bf0c34c014824a9c844dd240074c97a9e9ccd8510b081dd9c8813fccaaaeccc00'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
