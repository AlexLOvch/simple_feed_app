# frozen_string_literal: true

require 'open-uri'

class ApartmentsController < ApplicationController
  def index
    render 'index', locals: { apartments: Apartment.with_topmost_agency }
  rescue Exceptions::DataLoadError
    render 'loading_data_error'
  end
end
