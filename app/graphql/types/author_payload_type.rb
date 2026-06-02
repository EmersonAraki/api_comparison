# frozen_string_literal: true

module Types
  class AuthorPayloadType < Types::BaseObject
    field :author, Types::AuthorType, null: true
    field :errors, [ String ], null: false
  end
end
