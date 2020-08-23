class Libraries < Sinatra::Base
  get '/libraries' do
    lang = params[:language]

    results = LibrariesFetcher
                .call(using: %i(gitlab github), filters: { language: lang })
                .sort_by(:updated_at)
                .as_json(only: %i(url owner name description host))

    { data: results }.to_json
  end
end
