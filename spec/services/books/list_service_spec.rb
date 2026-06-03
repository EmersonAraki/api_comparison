# frozen_string_literal: true

RSpec.describe Books::ListService do
  describe '#call' do
    it 'returns all books with authors eager-loaded', :aggregate_failures do
      author = Author.create!(name: 'Author')
      book = Book.create!(title: 'Book', published_year: 2020, author: author)

      result = described_class.new.call

      expect(result).to include(book)
      expect(result.first.association(:author)).to be_loaded
    end

    it 'returns an empty collection when no books exist' do
      expect(described_class.new.call).to be_empty
    end
  end
end
