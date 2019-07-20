# frozen_string_literal: true

module Loadable
  extend ActiveSupport::Concern

  class_methods do
    def loadable(options = {})
      @loading_options = options
    end

    def loading_options
      @loading_options
    end
    # allows to convert data to attributes hash
    # input {"cooper_and_cooper"=>10, "loftey"=>9, "triplemint"=>8}
    # output [{"agency_name" => "cooper_and_cooper", "proirity"=>10, ...}
    def preprocess_data(data)
      if loading_options[:convert_to_attr_hash]
        data.map do |k,v|
          keys = column_names - ['id']
          keys.zip([k,v]).to_h
        end
      else
        data
      end
    end

    def load_validation_errors
      @load_validation_errors || []
    end

    def validate_data(data)
      return data unless loading_options[:validate_data]

      @valid_data = []
      @load_validation_errors = []

      data.each do |data_row|
        new_instance = new(data_row)
        if new_instance.valid?
          @valid_data << new_instance
        else
          @load_validation_errors << { line: data_row, error_messages: new_instance.errors.full_messages }
        end
      end
      Rails.logger.error "Wrong data while loading #{name}: #{@load_validation_errors}" if @load_validation_errors.any?

      @valid_data
    end

    def loaded_data
      return @loaded_data if @loaded_data

      @loaded_data = load_data
    end

    def load_data
      @loaded_data = validate_data(preprocess_data(Parser.parse(Loader.load(loading_options[:from]))))
    rescue StandardError => e
      Rails.logger.error("Loading data error: #{name} - #{e.message}")
      @loaded_data = []
    end

    def load!
      load_data
      if loaded_data.any?
        destroy_all
        loaded_data.each(&:save)
        return true
      end

      false
    end
  end
end
