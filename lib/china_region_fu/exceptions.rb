module ChinaRegionFu
  class InvalidAttributeError < StandardError
    def initialize
      super 'Region attribute is not valid.'
    end
  end
end