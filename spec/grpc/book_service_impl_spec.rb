# frozen_string_literal: true

RSpec.describe BookServiceImpl do
  subject(:service) { described_class.new }

  let(:author) { Author.create!(name: 'Test Author') }

  describe '#list_books' do
    it 'returns all books' do
      Book.create!(title: 'Book One', published_year: 2020, author: author)

      response = service.list_books(Bookshelf::ListBooksRequest.new, nil)

      expect(response.books.length).to eq(1)
      expect(response.books.first.title).to eq('Book One')
    end
  end

  describe '#get_book' do
    it 'returns the book' do
      book = Book.create!(title: 'Book One', published_year: 2020, author: author)

      response = service.get_book(Bookshelf::GetBookRequest.new(id: book.id.to_s), nil)

      expect(response.book.title).to eq('Book One')
    end

    it 'raises GRPC::NotFound for an unknown id' do
      expect { service.get_book(Bookshelf::GetBookRequest.new(id: '0'), nil) }
        .to raise_error(GRPC::NotFound)
    end
  end

  describe '#create_book' do
    it 'creates a book and returns it' do
      request = Bookshelf::CreateBookRequest.new(
        title: 'New Book',
        published_year: 2024,
        author_id: author.id.to_s
      )

      response = service.create_book(request, nil)

      expect(response.book.title).to eq('New Book')
    end

    it 'raises GRPC::InvalidArgument when title is blank' do
      request = Bookshelf::CreateBookRequest.new(
        title: '',
        published_year: 2024,
        author_id: author.id.to_s
      )

      expect { service.create_book(request, nil) }.to raise_error(GRPC::InvalidArgument)
    end
  end

  describe '#create_author' do
    it 'creates an author and returns it' do
      request = Bookshelf::CreateAuthorRequest.new(name: 'New Author', bio: 'Bio text')

      response = service.create_author(request, nil)

      expect(response.author.name).to eq('New Author')
    end

    it 'raises GRPC::InvalidArgument when name is blank' do
      request = Bookshelf::CreateAuthorRequest.new(name: '')

      expect { service.create_author(request, nil) }.to raise_error(GRPC::InvalidArgument)
    end
  end
end
