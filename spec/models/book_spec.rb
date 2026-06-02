# frozen_string_literal: true

RSpec.describe Book, type: :model do
  let(:author) { Author.create!(name: 'Jane Austen') }

  it 'is valid with a title, published_year, and author' do
    expect(described_class.new(title: 'Emma', published_year: 1815, author: author)).to be_valid
  end

  it 'is invalid without a title' do
    expect(described_class.new(title: '', published_year: 1815, author: author)).not_to be_valid
  end

  it 'is invalid without a published_year' do
    expect(described_class.new(title: 'Emma', published_year: nil, author: author)).not_to be_valid
  end

  it 'returns its author' do
    book = described_class.create!(title: 'Emma', published_year: 1815, author: author)
    expect(book.author).to eq(author)
  end
end
