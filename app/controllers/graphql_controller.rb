# frozen_string_literal: true

class GraphqlController < ApplicationController
  def execute
    query = params[:query]
    return render json: { errors: [ { message: "No query string was present" } ] }, status: :bad_request if query.blank?

    variables = prepare_variables(params[:variables])
    operation_name = params[:operationName]
    result = ApiComparisonSchema.execute(
      query,
      variables: variables,
      context: {},
      operation_name: operation_name
    )
    render json: result
  rescue StandardError => e
    logger.error e.message
    raise e if Rails.env.production?
    render json: { errors: [ { message: e.message } ], data: {} }, status: :internal_server_error
  end

  private

  def prepare_variables(variables_param)
    case variables_param
    when String
      variables_param.present? ? JSON.parse(variables_param) : {}
    when Hash, ActionController::Parameters
      variables_param.to_unsafe_hash
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  rescue JSON::ParserError
    raise ArgumentError, "Variables must be valid JSON"
  end
end
