# frozen_string_literal: true

module Authors
  class CreateService
    def call(name:, bio: nil)
      author = Author.new(name: name, bio: bio)
      if author.save
        Result.new(success: true, record: author, errors: [])
      else
        Result.new(success: false, record: nil, errors: author.errors.full_messages)
      end
    end
  end
end
