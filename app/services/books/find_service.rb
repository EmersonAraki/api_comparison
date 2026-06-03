# frozen_string_literal: true

module Books
  class FindService
    def call(id:)
      book = Book.includes(:author).find(id)
      Result.new(success: true, record: book, errors: [])
    rescue ActiveRecord::RecordNotFound
      Result.new(success: false, record: nil, errors: [ "Book not found" ])
    end
  end
end
