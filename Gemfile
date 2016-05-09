source 'http://rubygems.org'

gemspec

#gem 'emojidex', '~> 0.2.0'
gem 'emojidex', path: '../emojidex'

group :development do
  gem 'rb-inotify', require: false
  gem 'rb-fsevent', require: false
  gem 'guard'
  gem 'guard-rspec'
  gem 'rubocop'
  gem 'guard-rubocop'

  gem 'emojidex-vectors', require: false
end

group :test do
  gem 'rspec'
end
