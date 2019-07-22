# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Agency, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:agency_apartments) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:agency_name) }
    it { is_expected.to validate_presence_of(:priority) }
    it { is_expected.to validate_numericality_of(:priority) }
  end
end
