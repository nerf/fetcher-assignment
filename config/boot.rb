# frozen_string_literal: true

env = ENV['RACK_ENV'] ||= 'production'

require 'rubygems'
require 'bundler/setup'
Bundler.require(env.to_sym)
require 'dalli'
require 'rack-cache'

Dir['./app/{lib,models,services}/**/*.rb'].each { |file| require file }

require './app/controllers/application'
