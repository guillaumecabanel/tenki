require 'httparty'

require_relative 'forecast_icons'
require_relative 'day_forecast'

class Forecast
  attr_reader :city, :today, :tomorrow, :day_after_tomorrow, :now_temp

  BASE_URL = ENV['FORECAST_API_URL']

  CITIES = %w[Annecy Biarritz Bordeaux Bruxelles Chambery Geneve Grenoble Lille Londres Lyon Marseille Metz Montpellier Nantes Nice Paris Rouen Toulouse]

  def initialize(city)
    return unless CITIES.map(&:downcase).include? city.downcase

    @city = city

    response = HTTParty.get("#{BASE_URL}#{@city.downcase}")
    return if response.client_error?

    forecasts  = response['previsions']
    previsions = forecasts['prevision']

    @today              = DayForecast.new(@city, previsions[1])
    @tomorrow           = DayForecast.new(@city, previsions[2])
    @day_after_tomorrow = DayForecast.new(@city, previsions[3])
    @now_temp           = forecasts['TempInst']
  end
end
