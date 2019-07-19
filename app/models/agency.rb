# frozen_string_literal: true

class Agency < ApplicationRecord
  include Loadable
  loadable from: 'https://raw.githubusercontent.com/kirillplatonov/apartments-feed-test/master/rental_agencies.yml',
    convert_to_attr_hash: true, validate_data: true

  has_many :agency_apartments, dependent: :delete_all

  validates :agency_name, :priority, presence: true
  validates :priority, numericality: { only_integer: true }
end
