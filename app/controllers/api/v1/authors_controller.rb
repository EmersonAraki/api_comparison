# frozen_string_literal: true

module Api
  module V1
    class AuthorsController < ApplicationController
      def create
        result = Authors::CreateService.new.call(
          name: author_params[:name],
          bio: author_params[:bio]
        )
        if result.success?
          render json: result.record, status: :created
        else
          render json: { errors: result.errors }, status: :unprocessable_content
        end
      end

      private

      def author_params
        params.permit(:name, :bio)
      end
    end
  end
end
