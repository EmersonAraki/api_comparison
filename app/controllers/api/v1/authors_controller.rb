# frozen_string_literal: true

module Api
  module V1
    class AuthorsController < ApplicationController
      def create
        result = Authors::CreateService.new.call(
          name: params[:name],
          bio: params[:bio]
        )
        if result.success?
          render json: result.record, status: :created
        else
          render json: { errors: result.errors }, status: :unprocessable_content
        end
      end
    end
  end
end
