RSpec.describe Application do
  describe 'GET /' do
    it 'returns JSON response with available endpoints' do
      get '/'

      expect(last_response).to be_ok
      # TODO: Replace me
      expect(resp_obj['message']).to match(/info/)
    end
  end
end
