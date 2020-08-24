RSpec.describe LibrariesFetcher::Github do
  describe '.latest_public_libraries' do
    context 'with results' do
      let(:project_name) { 'k8s' }
      let(:username) { 'google' }
      let(:description) { 'k8s is automated...' }
      let(:url) { 'http://example.com/google/k8s' }
      let(:updated_at) { '2019-09-06T10:53:54+00:00' }
      let(:source) { 'github' }
      let(:lang) { 'ruby' }
      let(:api_endpoint) { described_class::API_ENDPOINT }
      let(:parsed_response) do
        {
          'data' => {
            'search' => {
              'edges' => [
                { 
                  'node' => {
                    'owner' => { 'login' => username },
                    'name' => project_name,
                    'description' => description,
                    'url' => url,
                    'updatedAt' => updated_at,
                    'source' => source
                  }
                }
              ]
            }
          }
        }
      end
      let(:query) do
        described_class::Queries.latest_public_libraries(
          limit: described_class::DEFAULT_LIMIT,
          order: described_class::DEFAULT_ORDER,
          lang: lang
        )
      end

      before do
        client = double('Client')

        allow(client).to receive(:post).with(query: query).and_return(parsed_response)
        allow(Fetch::HTTP::Client).to receive(:new).with(api_endpoint).and_return(client)
      end

      it 'returns list of library instances' do
        result = described_class.latest_public_libraries(lang: lang)

        expect(result.length).to eq(1)
        expect(result[0].name).to eq(project_name)
        expect(result[0].username).to eq(username)
        expect(result[0].description).to eq(description)
        expect(result[0].url).to eq(url)
        expect(result[0].updated_at).to be_kind_of(DateTime)
        expect(result[0].source).to eq(source)
      end
    end
  end
end
