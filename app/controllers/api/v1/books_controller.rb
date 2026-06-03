# frozen_string_literal: true

module Api
  module V1
    class BooksController < ApplicationController
      def index
        books = Books::ListService.new.call
        render json: books.as_json(include: :author)
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
          title: params[:title],
          published_year: params[:published_year],
          author_id: params[:author_id]
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
