source 'https://rubygems.org'
ruby '2.2.4'
gem 'rails', '4.2.5.1'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'figaro'
gem 'sprockets-rails', '~> 3.0', '>= 3.0.1'
gem 'activeadmin', github: 'activeadmin'
gem "font-awesome-rails"
gem "paperclip", git: "git://github.com/thoughtbot/paperclip.git"
gem 'roo', '~> 2.1.0'
gem "wysiwyg-rails"
gem "paperclip-dropbox", ">= 1.1.7"
gem 'will_paginate-bootstrap'
gem 'wicked'
# Stores session in database not in cookie
gem 'activerecord-session_store', github: 'rails/activerecord-session_store'

group :development, :test do
  gem 'byebug'
end
group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem "passenger"
end

gem 'devise'
gem 'annotate'
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.37'
gem 'jquery-ui-rails'
gem 'best_in_place', '~> 3.0.1'

# Webservers
group :production do
	gem 'unicorn'
	gem 'rails_12factor'
end

gem 'bootstrap-sass'
gem 'high_voltage'
gem 'pg'
gem 'simple_form'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_21]
  gem 'hub', :require=>nil
  gem 'quiet_assets'
  gem 'rails_layout'
  gem "letter_opener"
end

# Deployement
group :development do
  gem 'capistrano', '~> 3.4'
  gem 'capistrano-rails', '~> 1.1', '>= 1.1.6'
  gem 'capistrano-rbenv', '~> 2.0', '>= 2.0.4'
  gem 'capistrano-rails-console', '~> 1.0', '>= 1.0.2'
  gem 'sshkit-sudo'
end