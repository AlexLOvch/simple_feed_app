# frozen_string_literal: true

class Agency
  include ActiveModel::Validations
  include Loadable
  include Validable

  loadable from: 'https://raw.githubusercontent.com/kirillplatonov/apartments-feed-test/master/rental_agencies.yml'

  attr_accessor :agency_name, :priority
  validates :agency_name, :priority, presence: true
  validates :priority, numericality: { only_integer: true }

  def initialize(attr_array)
    @agency_name = attr_array[0]
    @priority = attr_array[1]
  end

  class << self
    def agency_names
      valid_data.map(&:agency_name)
    end

    def max_priority
      return @max_priority if @max_priority

      @max_priority = valid_data.max(&:priority).priority
    end

    def find_by_name(name)
      valid_data.find { |agency| agency.agency_name == name }
    end
  end
end
