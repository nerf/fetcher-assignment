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
    # TODO: Replace me
    { message: 'show api info' }.to_json
  end
end
