# frozen_string_literal: true

module Loadable
  extend ActiveSupport::Concern

  class_methods do
    def loadable(options)
      @loading_options = options
    end

    def loading_options
      @loading_options
    end

    def raw_data
      return @raw_data if @raw_data

      @raw_data = load_data
    end

    def load_data
      YAML.safe_load(open(loading_options[:from], &:read))
    rescue StandardError => e
      Rails.logger.error("Loading data error: #{name} - #{e.message}")
      raise Exceptions::DataLoadError
    end
  end
end
