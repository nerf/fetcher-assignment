RSpec.describe Fetch::HTTP::Client do
  let(:uri) { 'https://example.com/api' }

  subject { Fetch::HTTP::Client.new(uri) }

  describe '#get' do
    context 'successful response' do
      it 'should make request and return response object' do
        stub_request(
          :get, "#{uri}?language=javascript"
        ).to_return(status: 200, body: '')

        response = subject.get(language: 'javascript')

        expect(response).to be_kind_of(Net::HTTPOK)
      end
    end

    context 'unsuccessful request' do
      it 'should make request and return response object' do
        stub_request(:get, uri).to_return(status: 404, body: '')

        response = subject.get()

        expect(response).to be_kind_of(Net::HTTPNotFound)
      end
    end
  end
end
