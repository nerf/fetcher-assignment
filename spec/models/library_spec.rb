RSpec.describe Library do
  it 'can be initiated using keywords' do
    library = Library.new name: 'Foo', username: 'Bar'

    expect(library.name).to eq('Foo')
    expect(library.username).to eq('Bar')
  end
end
