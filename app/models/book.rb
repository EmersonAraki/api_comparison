# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :author

  validates :title, presence: true
  validates :published_year, presence: true, numericality: { only_integer: true }
end
