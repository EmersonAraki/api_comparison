# frozen_string_literal: true

module Books
  class ListService
    def call
      Book.includes(:author).all
    end
  end
end
