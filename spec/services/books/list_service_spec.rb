# frozen_string_literal: true

RSpec.describe Books::ListService do
  describe '#call' do
    it 'returns a successful result with books and authors eager-loaded', :aggregate_failures do
      author = Author.create!(name: 'Author')
      book = Book.create!(title: 'Book', published_year: 2020, author: author)

      result = described_class.new.call

      expect(result.success?).to be true
      expect(result.record).to include(book)
      expect(result.record.first.association(:author)).to be_loaded
    end

    it 'returns a successful result with an empty collection when no books exist', :aggregate_failures do
      result = described_class.new.call

      expect(result.success?).to be true
      expect(result.record).to be_empty
    end
  end
end
