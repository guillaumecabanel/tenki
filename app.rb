require 'sinatra'
require_relative 'helpers.rb'
require_relative 'lib/forecast.rb'

get '/:city' do
  @icons    = Forecast::ICONS
  @today    = Forecast.today(params[:city])
  @now_temp = Forecast.now_temp(params[:city])

  slim :index
end
