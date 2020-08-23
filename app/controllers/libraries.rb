class Libraries < Sinatra::Base
  get '/libraries' do
    lang = params[:language]

    results = LibrariesFetcher
                .call(using: [Fetch::Gitlab, Fetch::Github], lang: lang)
                .sort_by(:updated_at)
                .as_json(only: %i(url username name description source))

    { data: results }.to_json
  rescue Fetch::HTTP::Client::RequestError => e
    { error: true, message: e.message }.to_json
  end
end
