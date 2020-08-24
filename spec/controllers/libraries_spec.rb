RSpec.describe Libraries do
  describe 'GET /libraries' do
    let(:gitlab_url) { 'https://gitlab.com/api/v4/projects?order_by=updated_at&per_page=50' }

    context 'succeeds' do
      let(:gitlab_url) { 'https://gitlab.com/api/v4/projects?order_by=updated_at&per_page=50&with_programming_language=ruby' }
      let(:gitlab_results) do
        [
          {
            id: 'FAKE-ID',
            path_with_namespace: 'ruby/rake',
            name: 'rake',
            description: 'make for ruby',
            web_url: 'http://example.com',
            last_activity_at: '2013-09-30T13:46:02Z'
          }
        ].to_json
      end
      let(:github_result) do
        { 
          data: {
            search: {
              edges: []
            }
          }
        }.to_json
      end

      before do
        stub_request(:get, gitlab_url)
          .to_return(status: 200, body: gitlab_results)
        stub_request(:post, LibrariesFetcher::Github::API_ENDPOINT)
          .to_return(status: 200, body: github_result)

        get '/libraries', language: 'ruby'
      end

      it 'returns list of libraries' do
        expected_result = {
          'username' => 'ruby', 'name' => 'rake',
          'description' => 'make for ruby', 'url' => 'http://example.com',
          'source' => 'gitlab'
        }

        expect(resp_obj['data'].length).to eq(1)
        expect(resp_obj['data'].first).to match(expected_result)
      end
    end

    context 'timeouts' do
      before do
        stub_request(:get, gitlab_url).to_timeout

        get '/libraries'
      end

      it 'returns error message' do
        expect(resp_obj['error']).to be_truthy
        expect(resp_obj['message']).to match(/timed out/i)
      end
    end

    context 'malformed response' do
      before do
        stub_request(:get, gitlab_url).to_return(body: 'invalid-response')

        get '/libraries'
      end

      it 'returns error message' do
        expect(resp_obj['error']).to be_truthy
        expect(resp_obj['message']).to match(/invalid data/i)
      end
    end
  end
end
