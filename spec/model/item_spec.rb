require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:qty) }
    it { is_expected.to validate_presence_of(:price) }
  end
end
