# frozen_string_literal: true
class ApartmentsController < ApplicationController
  def index
    render 'index', locals: { apartments: Apartment.with_topmost_agency }
  rescue StandardError
    render 'loading_data_error'
  end
end
