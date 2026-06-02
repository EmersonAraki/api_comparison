# frozen_string_literal: true

Result = Struct.new(:success, :record, :errors, keyword_init: true) do
  def success? = success
end
