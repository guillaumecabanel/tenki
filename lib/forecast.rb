require 'httparty'

class Forecast
  attr_reader :city,
              :date,
              :description,
              :sunrise,
              :sunset,
              :morning_min_temp,
              :morning_max_temp,
              :morning_pic,
              :afternoon_min_temp,
              :afternoon_max_temp,
              :afternoon_pic,
              :evening_min_temp,
              :evening_max_temp,
              :evening_pic,
              :night_min_temp,
              :night_max_temp,
              :night_pic

  BASE_URL = ENV['FORECAST_API_URL']

  CITIES = %w[Annecy Biarritz Bordeaux Bruxelles Chambery Geneve Grenoble Lille Londres Lyon Marseille Metz Montpellier Nantes Nice Paris Rouen Toulouse]

  ICONS = [
    '0',
    'sun',
    'sun-cloud',
    'sun-cloud',
    'clouds-sun',
    'cloud-sun-rain',
    'cloud-sun-rain',
    'cloud-sun-rain',
    'snowflake',
    'snowflake',
    '10',
    'thunderstorm-sun',
    'thunderstorm-sun',
    'snowflake',
    'clouds',
    'cloud-rain',
    'cloud-drizzle',
    'cloud-drizzle',
    'cloud-sleet',
    'cloud-snow',
    'cloud-snow',
    'smog',
    'thunderstorm',
    'moon-stars',
    'cloud-moon',
    'clouds-moon',
    'clouds-moon',
    'cloud-moon-rain',
    'cloud-moon-rain',
    'snowflake',
    'snowflake',
    'snowflake',
    '32',
    'thunderstorm',
    'thunderstorm',
    '35',
    'bolt',
    'snowflake',
    '38',
    '39',
    'sun-haze',
    'clouds-sun',
    'cloud-moon',
    'clouds-moon',
    'sun-haze',
    'cloud-moon'
  ]

  class << self
    def forecasts_data(city)
      query = HTTParty.get("#{BASE_URL}#{city.downcase}")

      query['previsions'] if query
    end

    def now_temp(city)
      query = HTTParty.get("#{BASE_URL}#{city.downcase}")

      query['previsions']['TempInst'] if query
    end

    def today(city)
      new(city, forecasts_data(city)['prevision'][1])
    end

    def tomorrow(city)
      new(city, forecasts_data(city)['prevision'][2])
    end
  end

  def initialize(city, attributes = {})
    @city               = city.capitalize
    @date               = Date.parse(attributes['dateIso'])
    @sunrise            = attributes['leverSoleil']
    @sunset             = attributes['coucherSoleil']

    @morning_min_temp   = attributes['tempMinMatin'].to_i
    @morning_max_temp   = attributes['tempMaxMatin'].to_i
    @afternoon_min_temp = attributes['tempMinApresMidi'].to_i
    @afternoon_max_temp = attributes['tempMaxApresMidi'].to_i
    @evening_min_temp   = attributes['tempMinSoir'].to_i
    @evening_max_temp   = attributes['tempMaxSoir'].to_i
    @night_min_temp     = attributes['tempMinNuit'].to_i
    @night_max_temp     = attributes['tempMaxNuit'].to_i

    @morning_pic        = attributes["pictoMatin"].to_i
    @afternoon_pic      = attributes["pictoApresMidi"].to_i
    @evening_pic        = attributes["pictoSoiree"].to_i
    @night_pic          = attributes["pictoNuit"].to_i

    @description        = parse_description(attributes['commentaire'])
  end

  private

  def parse_description(raw_description)
    raw_description.gsub(/(\s)?<\/?p>/, '')
  end
end
