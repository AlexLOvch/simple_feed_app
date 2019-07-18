# frozen_string_literal: true

require 'open-uri'

class ApartmentsController < ApplicationController
  def index
    render 'index', locals: { apartments: Apartment.filtered_data }
  rescue Exceptions::DataLoadError
    render 'loading_data_error'
  end
end
