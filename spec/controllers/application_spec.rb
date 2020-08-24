RSpec.describe Application do
  describe 'GET /' do
    it 'returns JSON response with available endpoints' do
      get '/'

      expect(last_response).to be_ok
      expect(resp_obj['resources']).not_to be_empty
    end
  end
end
