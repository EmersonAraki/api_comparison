# frozen_string_literal: true

RSpec.describe Books::FindService do
  describe '#call' do
    let(:author) { Author.create!(name: 'Author') }

    it 'returns the book with author eager-loaded' do
      book = Book.create!(title: 'Book', published_year: 2020, author: author)

      result = described_class.new.call(id: book.id)

      expect(result).to eq(book)
      expect(result.association(:author)).to be_loaded
    end

    it 'raises ActiveRecord::RecordNotFound for an unknown id' do
      expect { described_class.new.call(id: 0) }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
