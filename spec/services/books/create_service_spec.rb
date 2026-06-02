# frozen_string_literal: true

RSpec.describe Books::CreateService do
  describe '#call' do
    let(:author) { Author.create!(name: 'Author') }

    it 'creates a book and returns a successful result', :aggregate_failures do
      result = described_class.new.call(title: 'New Book', published_year: 2024, author_id: author.id)

      expect(result.success?).to be true
      expect(result.record).to be_a(Book)
      expect(result.errors).to be_empty
    end

    it 'returns a failed result with errors when title is blank', :aggregate_failures do
      result = described_class.new.call(title: '', published_year: 2024, author_id: author.id)

      expect(result.success?).to be false
      expect(result.record).to be_nil
      expect(result.errors).not_to be_empty
    end
  end
end
