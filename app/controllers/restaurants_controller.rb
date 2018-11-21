class RestaurantsController < ApplicationController

  def index
    @restaurants = Restaurant.all
    @averages = {}
    @restaurants.each do |resto|
      if resto.reviews.empty?
        @averages[resto] = 0
      else
        @averages[resto] = ((resto.reviews.map { |review| review.rating }.reduce(:+) + 0.0) / resto.reviews.count).round(1)
      end
    end
    @restaurants = @restaurants.sort { |resto1, resto2| @averages[resto2] <=> @averages[resto1] }
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.reviews.empty?
      @average = 'tbd'
    else
      @average = ((@restaurant.reviews.map { |review| review.rating }.reduce(:+) + 0.0) / @restaurant.reviews.count).round(1)
    end
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if @restaurant.save
      redirect_to restaurant_path(@restaurant)
    else
      render :new
    end
  end

  private

    def restaurant_params
      params.require(:restaurant).permit(:name, :category, :address, :phone_number)
    end
end
