# frozen_string_literal: true

module Validable
  extend ActiveSupport::Concern
  class_methods do
    def valid_data
      return @valid_data if @valid_data

      @valid_data = []
      @errors = []

      raw_data.each do |data_row|
        new_instance = new(data_row)
        if new_instance.valid?
          @valid_data << new_instance
        else
          @errors << { line: data_row, error_messages: new_instance.errors.full_messages }
        end
      end
      Rails.logger.error "Wrong data while loading #{name}: #{@errors}" if @errors.any?

      @valid_data
    end
  end
end
