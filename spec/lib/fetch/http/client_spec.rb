RSpec.describe Fetch::HTTP::Client do
  let(:uri) { 'https://example.com/api' }

  subject { Fetch::HTTP::Client.new(uri) }

  describe '#get' do
    context 'successful response' do
      it 'should make request and return response object' do
        stub_request(
          :get, "#{uri}?language=javascript"
        ).to_return(status: 200, body: '')

        response = subject.get(language: 'javascript', nil: nil)

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

  describe '#post' do
    context 'successful response' do
      let(:request_body) { JSON.generate({ foo: 'bar' }) }

      it 'should make request and return response' do
        stub_request(:post, uri).with(body: request_body).to_return(status: 200)

        response = subject.post({ foo: 'bar', nil: nil })

        expect(response).to be_kind_of(Net::HTTPOK)
      end
    end
  end
end
