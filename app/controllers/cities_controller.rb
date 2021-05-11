class CitiesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  def index
    @cities = City.all
    @markers = @cities.map do |city|
      {
        lat: city.latitude,
        lng: city.longitude
      }
    end
  end

  def show
    @city = City.find(params[:id])
  end
end
