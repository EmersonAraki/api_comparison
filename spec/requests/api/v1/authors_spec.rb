# frozen_string_literal: true

RSpec.describe 'POST /api/v1/authors', type: :request do
  it 'creates an author and returns 201', :aggregate_failures do
    post '/api/v1/authors', params: { name: 'New Author', bio: 'Bio text' }

    expect(response).to have_http_status(:created)
    expect(JSON.parse(response.body)['name']).to eq('New Author')
  end

  it 'returns 422 when name is blank', :aggregate_failures do
    post '/api/v1/authors', params: { name: '' }

    expect(response).to have_http_status(:unprocessable_entity)
    expect(JSON.parse(response.body)['errors']).not_to be_empty
  end
end
