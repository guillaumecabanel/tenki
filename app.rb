require 'sinatra'
require_relative 'helpers.rb'
require_relative 'lib/forecast.rb'

enable :sessions

get '/' do
  redirect(to("/#{session[:last_visited_city]}")) if session[:last_visited_city] && params[:reset_last_visited_city] != 'true'

  @cities = Forecast::CITIES
  slim :index
end

get '/:city' do
  session[:last_visited_city] = params[:city]

  @icons    = Forecast::ICONS
  @today    = Forecast.today(params[:city])
  @now_temp = Forecast.now_temp(params[:city])

  slim :show
end
