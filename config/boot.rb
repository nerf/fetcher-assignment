# frozen_string_literal: true

env = ENV['RACK_ENV'] ||= 'production'

require 'rubygems'
require 'bundler/setup'
Bundler.require(env.to_sym)
require 'dalli'
require 'rack-cache'

Dir['./lib/**/*.rb', './app/{models,services}/**/*.rb'].each do |file|
  require file
end

require './app/controllers/application'
