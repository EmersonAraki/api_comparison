# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :books, [ Types::BookType ], null: false, description: "Returns all books"
    field :book, Types::BookType, null: true, description: "Find a book by id" do
      argument :id, ID, required: true
    end

    def books
      Books::ListService.new.call.record
    end

    def book(id:)
      result = Books::FindService.new.call(id: id)
      result.record if result.success?
    end
  end
end
