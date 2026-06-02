# frozen_string_literal: true

module Mutations
  class CreateAuthor < Mutations::BaseMutation
    argument :name, String, required: true
    argument :bio, String, required: false

    type Types::AuthorPayloadType

    def resolve(name:, bio: nil)
      result = Authors::CreateService.new.call(name: name, bio: bio)
      { author: result.record, errors: result.errors }
    end
  end
end
