# frozen_string_literal: true

module Books
  class ListService
    def call
      Result.new(success: true, record: Book.includes(:author).to_a, errors: [])
    end
  end
end
