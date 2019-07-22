# frozen_string_literal: true

class Apartment < ApplicationRecord
  include Loadable
  loadable from: 'https://raw.githubusercontent.com/kirillplatonov/apartments-feed-test/master/apartments.yml',
           validate_data: true

  attr_accessor :rental_agency, :price

  has_many :agency_apartments, dependent: :destroy
  has_many :agencies, through: :agency_apartments

  validates :address, :apartment, :city, presence: true

  after_save :create_or_update_agency_apartment

  def self.with_topmost_agency
    includes(agency_apartments: :agency).map do |apartment|
      topmost_agency_apartment = apartment.agency_apartments.max { |a, b| a.agency.priority <=> b.agency.priority }
      apartment.rental_agency = topmost_agency_apartment.agency.agency_name
      apartment.price = topmost_agency_apartment.price
      apartment
    end
  end

  def parsed_price
    price[1..-1].to_f
  end

  def save
    if new_record? && existent_apartment = Apartment.find_by(address: address, apartment: apartment, city: city)
      existent_apartment.rental_agency = rental_agency
      existent_apartment.price = price
      existent_apartment.create_or_update_agency_apartment
      true
    else
      super
    end
  end

  protected

  def create_or_update_agency_apartment
    agency = Agency.find_by(agency_name: rental_agency)
    agency_apartment = AgencyApartment.find_or_initialize_by(agency_id: agency.id, apartment_id: id)
    agency_apartment.price = parsed_price
    agency_apartment.save
  end
end
