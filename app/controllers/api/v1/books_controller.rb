# frozen_string_literal: true

module Api
  module V1
    class BooksController < ApplicationController
      def index
        result = Books::ListService.new.call
        render json: result.record.as_json(include: :author)
      end

      def show
        result = Books::FindService.new.call(id: params[:id])
        if result.success?
          render json: result.record.as_json(include: :author)
        else
          render json: { error: "Not found" }, status: :not_found
        end
      end

      def create
        result = Books::CreateService.new.call(
          title: book_params[:title],
          published_year: book_params[:published_year],
          author_id: book_params[:author_id]
        )
        if result.success?
          render json: result.record.as_json(include: :author), status: :created
        else
          render json: { errors: result.errors }, status: :unprocessable_content
        end
      end

      private

      def book_params
        params.permit(:title, :published_year, :author_id)
      end
    end
  end
end
