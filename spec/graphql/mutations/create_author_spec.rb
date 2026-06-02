# frozen_string_literal: true

RSpec.describe Mutations::CreateAuthor do
  let(:mutation) do
    <<~GQL
      mutation($name: String!, $bio: String) {
        createAuthor(input: { name: $name, bio: $bio }) {
          author { id name bio }
          errors
        }
      }
    GQL
  end

  context 'with valid params' do
    it 'creates an author and returns it', :aggregate_failures do
      result = ApiComparisonSchema.execute(
        mutation,
        variables: { 'name' => 'New Author', 'bio' => 'A biography' }
      )

      payload = result.dig('data', 'createAuthor')
      expect(payload['author']['name']).to eq('New Author')
      expect(payload['errors']).to be_empty
    end
  end

  context 'with invalid params' do
    it 'returns errors and no author', :aggregate_failures do
      result = ApiComparisonSchema.execute(
        mutation,
        variables: { 'name' => '' }
      )

      payload = result.dig('data', 'createAuthor')
      expect(payload['author']).to be_nil
      expect(payload['errors']).not_to be_empty
    end
  end
end
