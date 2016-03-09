# Be sure to restart your server when you modify this file.
#ensures that current_user is preserved across subdomains
Rails.application.config.session_store :cookie_store, key: '_callisto_session', domain: :all, tld_length: 2
Rails.application.config.session_store :cookie_store, key: 'guest_token', domain: :all, tld_length: 2
