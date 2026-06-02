# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_book, mutation: Mutations::CreateBook
    field :create_author, mutation: Mutations::CreateAuthor
  end
end
