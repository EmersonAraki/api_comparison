# frozen_string_literal: true

RSpec.describe Authors::CreateService do
  describe '#call' do
    it 'creates an author and returns a successful result', :aggregate_failures do
      result = described_class.new.call(name: 'New Author', bio: 'A bio')

      expect(result.success?).to be true
      expect(result.record).to be_a(Author)
      expect(result.errors).to be_empty
    end

    it 'returns a failed result with errors when name is blank', :aggregate_failures do
      result = described_class.new.call(name: '')

      expect(result.success?).to be false
      expect(result.record).to be_nil
      expect(result.errors).not_to be_empty
    end
  end
end
