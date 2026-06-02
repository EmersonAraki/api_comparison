# frozen_string_literal: true

RSpec.describe Author, type: :model do
  it 'is valid with a name' do
    expect(described_class.new(name: 'Jane Austen')).to be_valid
  end

  it 'is invalid without a name' do
    expect(described_class.new(name: '')).not_to be_valid
  end
end
