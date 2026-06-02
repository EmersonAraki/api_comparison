# frozen_string_literal: true

module Api
  module V1
    class BooksController < ApplicationController
      def index
        books = Books::ListService.new.call
        render json: books.as_json(include: :author)
      end

      def show
        book = Books::FindService.new.call(id: params[:id])
        render json: book.as_json(include: :author)
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Not found" }, status: :not_found
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
