# frozen_string_literal: true

class ApiComparisonSchema < GraphQL::Schema
  query(Types::QueryType)
  mutation(Types::MutationType)
end
