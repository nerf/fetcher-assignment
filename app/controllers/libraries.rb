class Libraries < Sinatra::Base
  get '/libraries' do
    # TODO: return list of fetched repositories
    { data: [] }.to_json
  end
end
