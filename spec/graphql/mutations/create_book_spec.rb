# frozen_string_literal: true

RSpec.describe Mutations::CreateBook do
  let(:author) { Author.create!(name: 'Author') }

  let(:mutation) do
    <<~GQL
      mutation($title: String!, $publishedYear: Int!, $authorId: ID!) {
        createBook(input: { title: $title, publishedYear: $publishedYear, authorId: $authorId }) {
          book { id title publishedYear }
          errors
        }
      }
    GQL
  end

  context 'with valid params' do
    it 'creates a book and returns it', :aggregate_failures do
      result = ApiComparisonSchema.execute(
        mutation,
        variables: { 'title' => 'New Book', 'publishedYear' => 2024, 'authorId' => author.id.to_s }
      )

      payload = result.dig('data', 'createBook')
      expect(payload['book']['title']).to eq('New Book')
      expect(payload['errors']).to be_empty
    end
  end

  context 'with invalid params' do
    it 'returns errors and no book', :aggregate_failures do
      result = ApiComparisonSchema.execute(
        mutation,
        variables: { 'title' => '', 'publishedYear' => 2024, 'authorId' => author.id.to_s }
      )

      payload = result.dig('data', 'createBook')
      expect(payload['book']).to be_nil
      expect(payload['errors']).not_to be_empty
    end
  end
end
