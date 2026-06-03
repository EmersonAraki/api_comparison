# frozen_string_literal: true

module Books
  class ListService
    def call
      Book.includes(:author).to_a
    end
  end
end
