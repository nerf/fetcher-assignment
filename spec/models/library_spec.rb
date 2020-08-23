RSpec.describe Library do
  let(:library) { Library.new name: 'Foo', username: 'Bar' }

  describe '.new' do
    it 'can be initiated using keywords' do
      expect(library.name).to eq('Foo')
      expect(library.username).to eq('Bar')
    end
  end

  describe '#as_json' do
    it 'returns hash of object data' do
      expected_result = {
        url: nil, username: 'Bar', name: 'Foo', description: nil,
        source: nil, updated_at: nil
      }

      expect(library.as_json).to match(expected_result)
    end

    it 'can filter returned data with only keyword' do
      expected_result = { name: 'Foo', url: nil }

      expect(library.as_json(only: %i(name url))).to match(expected_result)
    end
  end
end
