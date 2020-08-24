# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'

require './app/controllers/libraries'

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  before do
    content_type 'application/json'
  end

  use Libraries

  get '/' do
    {
      resources: {
        libraries: '/libraries'
      }
    }.to_json
  end
end
