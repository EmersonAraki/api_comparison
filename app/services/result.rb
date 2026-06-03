# frozen_string_literal: true

Result = Data.define(:success, :record, :errors) do
  def success? = success
end
