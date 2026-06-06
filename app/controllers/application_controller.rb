# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from StandardError, with: :internal_server_error_response

  private

  def internal_server_error_response(err)
    logger.error err.message
    render json: { errors: [ "Internal server error" ] }, status: :internal_server_error
  end
end
