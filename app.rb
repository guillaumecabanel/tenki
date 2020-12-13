require 'sinatra'
require_relative 'helpers.rb'
require_relative 'lib/forecast.rb'

enable :sessions

get '/' do
  session[:last_visited_city] = nil if params[:reset_last_visited_city] == 'true'

  if session[:last_visited_city]
    redirect(to("/#{session[:last_visited_city]}"))
  else
    @cities = Forecast::CITIES
    slim :index
  end
end

get '/:city' do
  session[:last_visited_city] = params[:city]

  @icons    = Forecast::ICONS
  @forecast = Forecast.new(params[:city])

  pp @forecast

  slim :show
end
