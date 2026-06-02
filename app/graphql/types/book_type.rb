# frozen_string_literal: true

module Types
  class BookType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :published_year, Integer, null: false
    field :author, Types::AuthorType, null: false
  end
end
