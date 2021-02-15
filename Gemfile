source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.8'

gem 'rails', '~> 5.2.4', '>= 5.2.4.5'
gem 'puma', '~> 3.11'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rspec_api_documentation'
  gem 'rubocop', require: false
  gem 'spring-commands-rspec'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'webmock'
end
