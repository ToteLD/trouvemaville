class CitiesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  has_scope :max_population
  has_scope :max_age_average
  has_scope :location, using: %i[name max_distance_km], type: :hash

  def index
    @saved_search = SavedSearch.new
    @cities = apply_scopes(City).all

    @markers = @cities.map do |city|
      is_favorite = FavoriteCity.find_by(user: current_user, city: city).present? if current_user

        if rating(city) >= 75
          image_url = helpers.asset_url('green-marker.svg')
        elsif rating(city) >= 50
          image_url = helpers.asset_url('orange-marker.svg')
        elsif rating(city) < 50
          image_url = helpers.asset_url('red-marker.svg')
        end

        image_url = helpers.asset_url('favorite-star.svg') if is_favorite

      {
        lat: city.latitude,
        lng: city.longitude,
        id: city.id,
        image_url: image_url,
        infoWindow: render_to_string(partial: "info_window", locals: { city: city, doctor: params[:doctor],\
                                                                       network: params[:network],\
                                                                       fibre: params[:fibre],\
                                                                       commodity: params[:commodity],\
                                                                       supermarket: params[:supermarket],\
                                                                       primary_school: params[:primary_school],\
                                                                       secondary_school: params[:secondary_school],\
                                                                       max_population: params[:max_population],\
                                                                       handiwork: params[:handiwork],\
                                                                       butchery: params[:butchery],\
                                                                       bakery: params[:bakery],\
                                                                       grocery: params[:grocery],\
                                                                       bookstore: params[:bookstore],\
                                                                       clothe: params[:clothe],\
                                                                       shoestore: params[:shoestore],\
                                                                       fish_market: params[:fish_market],\
                                                                       it: params[:it],\
                                                                       hardware: params[:hardware],\
                                                                       jewellery: params[:jewellery],\
                                                                       cosmetic: params[:cosmetic],\
                                                                       optic: params[:optic],\
                                                                       plant: params[:plant],\
                                                                       age_average: params[:max_age_average],\
                                                                       rating: rating(city) })
      }
    end

    @city = params[:location][:name]
    @max_distance_km = params[:location][:max_distance_km]
    @max_population = params[:max_population]
    @max_age_average = params[:max_age_average]
  end

  def show
    @city = City.find(params[:id])
    @is_compared = ComparedCity.find_by(city: @city, comparator: current_user.comparator).present? if current_user
    @is_favorite = FavoriteCity.find_by(user: current_user, city: @city).present? if current_user
    @city_rating = rating(@city)

    #--------------------                    variables for thresholds                 ---------------------->
    @network_fibre_threshold = City::NETWORK_FIBRE_THRESHOLD #-- 4G rand fibre ate at 70% minimum (see model city.rb)
    @city_rating_middle_threshold = 75 #-- fibre rate at 75% minimum  -->
    @commodity_count_threshold = City::COMMODITY_COUNT_THRESHOLD #-- commodity count will be green if > 0 (see model city.rb)-->
    @city_rating_middle_threshold = 75  #-- city rating will be green above or equal to 75% -->
                                        #-- city rating will be orange above or equal to 50% and below 75% -->
    @city_rating_lower_threshold = 50   #-- city rating will be red below 50% -->

    respond_to do |format|
      format.html
      format.json {
        render json: {
          city: render_to_string(partial: "cities/city", layout: false, formats: [:html])
        }
      }
    end
  end

  private

  def rating(city)
    # pick-up all user criteria in url
    @doctor_presence = params[:doctor].present? && params[:doctor] == "1"
    @network_presence = params[:network].present? && params[:network] == "1"
    @fibre_presence = params[:fibre].present? && params[:fibre] == "1"
    @commodity_presence = params[:commodity].present? && params[:commodity] == "1"
    @supermarket_presence = params[:supermarket].present? && params[:supermarket] == "1"
    @primary_school_presence = params[:primary_school].present? && params[:primary_school] == "1"
    @secondary_school_presence = params[:secondary_school].present? && params[:secondary_school] == "1"
    @max_population_presence = params[:max_population].present? && params[:max_population].to_i >= 1
    @max_age_average_presence = params[:max_age_average].present? && params[:max_age_average].to_i >= 18
    @handiwork_presence = params[:handiwork].present? && params[:handiwork] == "1"
    @grocery_presence = params[:grocery].present? && params[:grocery] == "1"
    @butchery_presence = params[:butchery].present? && params[:butchery] == "1"
    @bakery_presence = params[:bakery].present? && params[:bakery] == "1"
    @bookstore_presence = params[:bookstore].present? && params[:bookstore] == "1"
    @clothe_presence = params[:clothe].present? && params[:clothe] == "1"
    @shoestore_presence = params[:shoestore].present? && params[:shoestore] == "1"
    @fish_market_presence = params[:fish_market].present? && params[:fish_market] == "1"
    @it_presence = params[:it].present? && params[:it] == "1"
    @hardware_presence = params[:hardware].present? && params[:hardware] == "1"
    @jewellery_presence = params[:jewellery].present? && params[:jewellery] == "1"
    @cosmetic_presence = params[:cosmetic].present? && params[:cosmetic] == "1"
    @optic_presence = params[:optic].present? && params[:optic] == "1"
    @plant_presence = params[:plant].present? && params[:plant] == "1"

    # city global rating calculation
    @criteria_selected_nb = 0

    @criteria_selected_nb += 1 if @doctor_presence
    @criteria_selected_nb += 1 if @network_presence
    @criteria_selected_nb += 1 if @fibre_presence
    @criteria_selected_nb += 1 if @commodity_presence
    @criteria_selected_nb += 1 if @supermarket_presence
    @criteria_selected_nb += 1 if @primary_school_presence
    @criteria_selected_nb += 1 if @secondary_school_presence
    @criteria_selected_nb += 1 if @max_population_presence
    @criteria_selected_nb += 1 if @max_age_average_presence
    @criteria_selected_nb += 1 if @handiwork_presence
    @criteria_selected_nb += 1 if @grocery_presence
    @criteria_selected_nb += 1 if @butchery_presence
    @criteria_selected_nb += 1 if @bakery_presence
    @criteria_selected_nb += 1 if @bookstore_presence
    @criteria_selected_nb += 1 if @clothe_presence
    @criteria_selected_nb += 1 if @shoestore_presence
    @criteria_selected_nb += 1 if @fish_market_presence
    @criteria_selected_nb += 1 if @it_presence
    @criteria_selected_nb += 1 if @hardware_presence
    @criteria_selected_nb += 1 if @jewellery_presence
    @criteria_selected_nb += 1 if @cosmetic_presence
    @criteria_selected_nb += 1 if @optic_presence
    @criteria_selected_nb += 1 if @plant_presence

    @match_criteria_nb = 0

    @match_criteria_nb += 1 if @doctor_presence && city.doctor
    @match_criteria_nb += 1 if @network_presence && city.network.to_f >= 70
    @match_criteria_nb += 1 if @fibre_presence && city.fibre.to_f >= 70
    @match_criteria_nb += 1 if @commodity_presence && city.commodity_count.positive?
    @match_criteria_nb += 1 if @supermarket_presence && city.supermarket
    @match_criteria_nb += 1 if @primary_school_presence && city.primary_school
    @match_criteria_nb += 1 if @secondary_school_presence && city.secondary_school
    @match_criteria_nb += 1 if @max_population_presence && city.population <= params[:max_population].to_i
    @match_criteria_nb += 1 if @max_age_average_presence && city.age_average <= params[:max_age_average].to_i
    @match_criteria_nb += 1 if @handiwork_presence && city.handiwork
    @match_criteria_nb += 1 if @grocery_presence && city.grocery
    @match_criteria_nb += 1 if @butchery_presence && city.butchery
    @match_criteria_nb += 1 if @bakery_presence && city.bakery
    @match_criteria_nb += 1 if @bookstore_presence && city.bookstore
    @match_criteria_nb += 1 if @clothe_presence && city.clothe
    @match_criteria_nb += 1 if @shoestore_presence && city.shoestore
    @match_criteria_nb += 1 if @fish_market_presence && city.fish_market
    @match_criteria_nb += 1 if @it_presence && city.it
    @match_criteria_nb += 1 if @hardware_presence && city.hardware
    @match_criteria_nb += 1 if @jewellery_presence && city.jewellery
    @match_criteria_nb += 1 if @cosmetic_presence && city.cosmetic
    @match_criteria_nb += 1 if @optic_presence && city.optic
    @match_criteria_nb += 1 if @plant_presence && city.plant
    
    if @criteria_selected_nb.positive?
      return ((@match_criteria_nb.to_f / @criteria_selected_nb) * 100).round
    else
      return 100
    end
  end
end
