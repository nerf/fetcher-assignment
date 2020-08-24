RSpec.describe Lib::API::Client do
  let(:uri) { 'https://example.com/api' }

  subject { described_class.new(uri) }

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

      it 'can make changes to request object by passing a block' do
        stub_request(:get, uri)
          .with(headers: { 'DUMMY' => 'HEADER' })
          .to_return(body: '[]')

        subject.get do |req|
          req['DUMMY'] = 'HEADER'
        end
      end
    end

    context 'unsuccessful request' do
      it 'raise error' do
        stub_request(:get, uri).to_return(status: 404, body: '')

        expect do
          subject.get()
        end.to raise_error(described_class::RequestError)
      end
    end

    context 'timeouts' do
      it 'raise error' do
        stub_request(:get, uri).to_timeout

        expect do
          subject.get
        end.to raise_error(described_class::RequestError)
      end
    end

    context 'malformed response' do
      it 'raise error' do
        stub_request(:get, uri).to_return(body: 'invalid-data')

        expect do
          subject.get
        end.to raise_error(described_class::RequestError)
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

      it 'can make changes to request object by passing a block' do
        stub_request(:post, uri)
          .with(headers: { 'DUMMY' => 'HEADER' })
          .to_return(body: '[]')

        subject.post do |req|
          req['DUMMY'] = 'HEADER'
        end
      end
    end

    context 'timeouts' do
      it 'raise error' do
        stub_request(:post, uri).to_timeout

        expect do
          subject.post
        end.to raise_error(described_class::RequestError)
      end
    end
  end
end
