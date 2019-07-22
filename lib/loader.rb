# frozen_string_literal: true

class Loader
  require 'open-uri'

  def self.load(source)
    open(source, &:read)
  end
end
