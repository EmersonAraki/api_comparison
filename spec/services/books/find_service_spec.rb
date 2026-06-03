# frozen_string_literal: true

RSpec.describe Books::FindService do
  describe '#call' do
    let(:author) { Author.create!(name: 'Author') }

    it 'returns a successful result with the book and author eager-loaded', :aggregate_failures do
      book = Book.create!(title: 'Book', published_year: 2020, author: author)

      result = described_class.new.call(id: book.id)

      expect(result.success?).to be true
      expect(result.record).to eq(book)
      expect(result.record.association(:author)).to be_loaded
    end

    it 'returns a failed result for an unknown id', :aggregate_failures do
      result = described_class.new.call(id: 0)

      expect(result.success?).to be false
      expect(result.record).to be_nil
      expect(result.errors).not_to be_empty
    end
  end
end
