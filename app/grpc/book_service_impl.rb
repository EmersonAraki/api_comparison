# frozen_string_literal: true

class BookServiceImpl < Bookshelf::BookService::Service
  def list_books(_request, _call)
    books = Books::ListService.new.call
    Bookshelf::ListBooksResponse.new(books: books.map { |b| book_to_message(b) })
  end

  def get_book(request, _call)
    result = Books::FindService.new.call(id: request.id)
    raise GRPC::NotFound.new("Book not found") unless result.success?

    Bookshelf::BookResponse.new(book: book_to_message(result.record), errors: [])
  end

  def create_book(request, _call)
    result = Books::CreateService.new.call(
      title: request.title,
      published_year: request.published_year,
      author_id: request.author_id
    )
    raise GRPC::InvalidArgument.new(result.errors.join(", ")) unless result.success?

    Bookshelf::BookResponse.new(book: book_to_message(result.record), errors: [])
  end

  def create_author(request, _call)
    result = Authors::CreateService.new.call(
      name: request.name,
      bio: request.bio.presence
    )
    raise GRPC::InvalidArgument.new(result.errors.join(", ")) unless result.success?

    Bookshelf::AuthorResponse.new(author: author_to_message(result.record), errors: [])
  end

  private

  def book_to_message(book)
    Bookshelf::BookMessage.new(
      id: book.id.to_s,
      title: book.title,
      published_year: book.published_year,
      author: author_to_message(book.author)
    )
  end

  def author_to_message(author)
    return Bookshelf::AuthorMessage.new if author.nil?

    Bookshelf::AuthorMessage.new(
      id: author.id.to_s,
      name: author.name,
      bio: author.bio.to_s
    )
  end
end
