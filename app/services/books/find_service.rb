# frozen_string_literal: true

module Books
  class FindService
    def call(id:)
      Book.includes(:author).find(id)
    end
  end
end
