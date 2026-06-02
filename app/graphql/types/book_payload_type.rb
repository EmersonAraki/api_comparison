# frozen_string_literal: true

module Types
  class BookPayloadType < Types::BaseObject
    field :book, Types::BookType, null: true
    field :errors, [ String ], null: false
  end
end
