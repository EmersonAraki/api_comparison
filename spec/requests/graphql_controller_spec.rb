# frozen_string_literal: true

RSpec.describe 'POST /graphql', type: :request do
  it 'returns 400 when body is missing' do
    post '/graphql'

    expect(response).to have_http_status(:bad_request)
  end

  it 'returns 200 with a valid query', :aggregate_failures do
    post '/graphql',
         params: '{"query":"{ books { id title } }"}',
         headers: { 'Content-Type' => 'application/json' }

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)).to have_key('data')
  end
end
