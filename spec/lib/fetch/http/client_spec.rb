RSpec.describe Fetch::HTTP::Client do
  let(:uri) { 'https://example.com/api' }

  subject { Fetch::HTTP::Client.new(uri) }

  describe '#get' do
    context 'successful response' do
      it 'returns parsed body' do
        stub_request(
          :get, "#{uri}?language=javascript"
        ).to_return(status: 200, body: '[]')

        result = subject.get(language: 'javascript', nil: nil)

        expect(result).to be_kind_of(Array)
        expect(result).to be_empty
      end
    end

    context 'unsuccessful request' do
      it 'raise error' do
        stub_request(:get, uri).to_return(status: 404, body: '')

        expect do
          subject.get()
        end.to raise_error(Fetch::HTTP::Client::RequestError)
      end
    end
  end

  describe '#post' do
    context 'successful response' do
      let(:request_body) { JSON.generate({ foo: 'bar' }) }

      it 'return parsed body' do
        stub_request(:post, uri)
          .with(body: request_body)
          .to_return(body: '{}', status: 200)

        result = subject.post({ foo: 'bar', nil: nil })

        expect(result).to be_kind_of(Hash)
        expect(result).to be_empty
      end
    end
  end
end
