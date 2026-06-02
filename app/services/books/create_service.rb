# frozen_string_literal: true

module Books
  class CreateService
    def call(title:, published_year:, author_id:)
      book = Book.new(title: title, published_year: published_year, author_id: author_id)
      if book.save
        Result.new(success: true, record: book, errors: [])
      else
        Result.new(success: false, record: nil, errors: book.errors.full_messages)
      end
    end
  end
end
