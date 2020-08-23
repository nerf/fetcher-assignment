RSpec.describe LibrariesFetcher do
  describe '#call' do
    let(:results) { described_class.call(using: [Fetch::Gitlab]) }

    before do
      allow(Fetch::Gitlab).to receive(:latest_public_libraries)

      results
    end

    it 'executes listed fetchers' do
      expect(Fetch::Gitlab).to have_received(:latest_public_libraries).with(lang: nil).once
    end

    it 'returns "results" object' do
      expect(results).to be_kind_of(described_class::Results)
    end
  end
end
