class Loader
  require 'open-uri'

  def self.load(source)
    open(source, &:read)
  end
end