# frozen_string_literal: true

require 'ostruct'

class Apartment
  include ActiveModel::Validations
  include Loadable
  include Validable

  loadable from: 'https://raw.githubusercontent.com/kirillplatonov/apartments-feed-test/master/apartments.yml'

  attr_accessor :address, :apartment, :city, :price, :rental_agency, :priority
  validates :address, :apartment, :city, :price, :rental_agency, presence: true
  validates :rental_agency, inclusion: { in: Agency.agency_names, message: 'Unknown agency' }

  def initialize(attr_hash)
    attr_hash.each { |k, v| public_send("#{k}=", v) }
  end

  def addr_str
    "#{city}#{address}#{apartment}"
  end

  class << self
    def with_agencies_priorities
      apartments = Apartment.valid_data
      apartments.each do |apartment|
        agency = Agency.find_by_name(apartment.rental_agency)
        apartment.priority = agency.priority
      end
      apartments
    end

    def filtered_data
      grouped = with_agencies_priorities.group_by(&:addr_str)
      sorted_groups = grouped.map { |_name, arr| arr.sort_by { |ap| Agency.max_priority - ap.priority } }
      sorted_groups.map(&:first)
    end
  end
end
