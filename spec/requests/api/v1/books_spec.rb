# frozen_string_literal: true

RSpec.describe 'GET /api/v1/books', type: :request do
  it 'returns a list of books' do
    author = Author.create!(name: 'Author')
    Book.create!(title: 'Book One', published_year: 2020, author: author)

    get '/api/v1/books'

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body).length).to eq(1)
  end
end

RSpec.describe 'GET /api/v1/books/:id', type: :request do
  it 'returns the book' do
    author = Author.create!(name: 'Author')
    book = Book.create!(title: 'Book One', published_year: 2020, author: author)

    get "/api/v1/books/#{book.id}"

    body = JSON.parse(response.body)
    expect(response).to have_http_status(:ok)
    expect(body['title']).to eq('Book One')
  end

  it 'returns 404 for an unknown id' do
    get '/api/v1/books/0'

    expect(response).to have_http_status(:not_found)
  end
end

RSpec.describe 'POST /api/v1/books', type: :request do
  let(:author) { Author.create!(name: 'Author') }

  it 'creates a book and returns 201', :aggregate_failures do
    post '/api/v1/books', params: { title: 'New Book', published_year: 2024, author_id: author.id }

    expect(response).to have_http_status(:created)
    expect(JSON.parse(response.body)['title']).to eq('New Book')
  end

  it 'returns 422 when title is blank', :aggregate_failures do
    post '/api/v1/books', params: { title: '', published_year: 2024, author_id: author.id }

    expect(response).to have_http_status(:unprocessable_content)
    expect(JSON.parse(response.body)['errors']).not_to be_empty
  end
end
