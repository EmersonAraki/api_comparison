# frozen_string_literal: true

class CreateAuthors < ActiveRecord::Migration[8.1]
  def change
    create_table :authors do |t|
      t.string :name, null: false
      t.text :bio

      t.timestamps
    end
  end
end
