# frozen_string_literal: true

source 'https://rubygems.org'

ruby '4.0.3'

gem 'rails', '~> 8.1'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'bootsnap', require: false

gem 'graphql', '~> 2.3'
gem 'grpc', '~> 1.65'

group :development do
  gem 'grpc-tools', '~> 1.65'
end

group :development, :test do
  gem 'rspec-rails', '~> 7.0'
end

group :test do
  gem 'database_cleaner-active_record', '~> 2.2'
end
