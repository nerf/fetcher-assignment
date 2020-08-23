RSpec.describe Libraries do
  describe 'GET /libraries' do
    it 'should return something (WIP)' do
      get '/libraries'

      expect(last_response).to be_ok
      expect(resp_obj['data']).to be_empty
    end
  end
end
