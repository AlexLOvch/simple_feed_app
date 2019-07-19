# frozen_string_literal: true

class AgencyApartment < ApplicationRecord
  belongs_to :agency
  belongs_to :apartment

  validates :price, numericality: true
end
