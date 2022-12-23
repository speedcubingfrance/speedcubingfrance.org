source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0'
gem 'rails-i18n', '~> 6.0'
gem 'i18n-country-translations'
# NOTE: we need to read/do the v3 to v4 migration at some point.
gem 'i18n-js', '~> 3'
gem 'http_accept_language'
gem 'shakapacker', '6.4.0'
# Use postgresql as the database for Active Record
gem 'pg'
# Form helper
gem 'simple_form'
# Nested association helper
gem 'cocoon'
# Markdown renderer
gem 'redcarpet'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc'
# Static pages
gem 'high_voltage'
# FIXME: do we actually need that gem?! We smtp directly to simgrid in prod
# mails
gem 'sendgrid-ruby'
# pagination
gem 'kaminari'
# export to ical
gem 'icalendar'
gem 'rest-client'
# Use puma as the app server
gem 'puma'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'dotenv-rails'
# To sync groups
gem 'google-apis-admin_directory_v1'

# To validate user uploads
gem 'active_storage_validations'

# To validate json schemas
gem 'json-schema'
gem 'i18n-tasks'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rails_layout'
  gem 'listen'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'rspec-rails'
end

