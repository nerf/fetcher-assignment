# frozen_string_literal: true

class Libraries < Sinatra::Base
  CACHE_MAX_AGE = 60

  before do
    cache_control :public, max_age: CACHE_MAX_AGE
    content_type 'application/json'
  end

  get '/libraries' do
    lang = params[:language]

    results = LibrariesFetcher
              .call(
                using: [LibrariesFetcher::Gitlab, LibrariesFetcher::Github],
                lang: lang
              )
              .sort_by(:updated_at)
              .as_json(only: %i[url username name description source])

    { data: results }.to_json
  rescue Lib::API::Client::RequestError => e
    halt 503, { error: true, message: e.message }.to_json
  end
end
