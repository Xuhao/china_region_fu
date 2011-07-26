class RegionController < ApplicationController
  
  def index
    @provinces = Province.select('id, name').all
  end
  
end