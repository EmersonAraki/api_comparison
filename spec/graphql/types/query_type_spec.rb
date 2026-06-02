# frozen_string_literal: true

RSpec.describe Types::QueryType do
  let(:author) { Author.create!(name: 'Jane Austen') }
  let!(:book) { Book.create!(title: 'Emma', published_year: 1815, author: author) }

  describe 'books query' do
    let(:query) do
      <<~GQL
        query {
          books {
            id
            title
            publishedYear
            author { name }
          }
        }
      GQL
    end

    it 'returns all books with authors', :aggregate_failures do
      result = ApiComparisonSchema.execute(query)
      books = result.dig('data', 'books')

      expect(books.length).to eq(1)
      expect(books.first['title']).to eq('Emma')
      expect(books.first.dig('author', 'name')).to eq('Jane Austen')
    end
  end

  describe 'book query' do
    let(:query) do
      <<~GQL
        query($id: ID!) {
          book(id: $id) { id title publishedYear }
        }
      GQL
    end

    it 'returns the book by id' do
      result = ApiComparisonSchema.execute(query, variables: { 'id' => book.id.to_s })
      expect(result.dig('data', 'book', 'title')).to eq('Emma')
    end

    it 'returns nil for an unknown id' do
      result = ApiComparisonSchema.execute(query, variables: { 'id' => '0' })
      expect(result.dig('data', 'book')).to be_nil
    end
  end
end
