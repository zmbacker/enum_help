source 'https://rubygems.org'

# Specify your gem's dependencies in enum_help.gemspec
gemspec

gem 'bundler'
gem 'rake'
gem 'rspec'
gem 'sqlite3'

case version = ENV['RAILS_VERSION']
when nil
  gem 'rails', '~> 7.0'
when 'edge'
  gem 'rails', github: 'rails/rails'
else
  gem 'rails', version
end
