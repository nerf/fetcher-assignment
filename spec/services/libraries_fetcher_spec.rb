Foo = Struct.new(:order) do
  def as_json(_args)
    'called'
  end
end

RSpec.describe LibrariesFetcher do
  describe described_class::Results do
    subject { described_class.new }

    describe '#<<' do
      it 'appends provided array' do
        subject << [1, 2, 3]
        subject << [4, 5]

        expect(subject.results).to match_array([1, 2, 3, 4, 5])
      end

      it "doesn't add nil value" do
        subject << [1, nil, 3]
        subject << [4, nil]

        expect(subject.results).to match_array([1, 3, 4])
      end
    end

    describe '#sort_by' do
      it 'sorts by attribute value' do
        subject << [Foo.new(3), Foo.new(1), Foo.new(2)]
        subject.sort_by(:order)

        aggregate_failures do
          expect(subject.results[0].order).to eq(1)
          expect(subject.results[1].order).to eq(2)
          expect(subject.results[2].order).to eq(3)
        end
      end
    end

    describe '#as_json' do
      it 'returns new list with results of as_json for each element' do
        subject << [Foo.new, Foo.new]

        expect(subject.as_json).to match_array(['called', 'called'])
      end
    end
  end

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
