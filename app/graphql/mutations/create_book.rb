# frozen_string_literal: true

module Mutations
  class CreateBook < Mutations::BaseMutation
    argument :title, String, required: true
    argument :published_year, Integer, required: true
    argument :author_id, ID, required: true

    type Types::BookPayloadType

    def resolve(title:, published_year:, author_id:)
      result = Books::CreateService.new.call(
        title: title,
        published_year: published_year,
        author_id: author_id
      )
      { book: result.record, errors: result.errors }
    end
  end
end
