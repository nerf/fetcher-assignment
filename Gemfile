# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'sinatra'
gem 'sinatra-contrib'
gem 'dalli'
gem 'rack-cache'

group :development, :test do
  gem 'rspec'
  gem 'pry'
  gem 'byebug'
end

group :test do
  gem 'rack-test'
  gem 'webmock'
end
