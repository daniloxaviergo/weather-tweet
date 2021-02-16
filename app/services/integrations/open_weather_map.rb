module Integrations
  class OpenWeatherMap
    API_KEY = ENV.fetch('OPEN_WEATHER_API_KEY')

    attr_accessor :errors, :tweet_text, :average_temperature

    def initialize(params)
      @params = params
      @errors = []
      @tweet_text = ''
      @average_temperature = {}
      @lang = params[:lang] || 'en'
      @unit = params[:unit] || 'metric'
    end

    def execute
      weather_api_init
      current_temperature
      forecast_temperature
      mount_text
    rescue ::OpenWeatherMap::Exceptions::UnknownLocation,
           ::OpenWeatherMap::Exceptions::Unauthorized,
           ::OpenWeatherMap::Exceptions::UnknownLang,
           ::OpenWeatherMap::Exceptions::UnknownUnits,
           ::OpenWeatherMap::Exceptions::DataError => e
      @errors.push(e.to_s)
    end

    private

    def weather_api_init
      @weather_api = ::OpenWeatherMap::API.new(API_KEY, @lang, @unit)
      @errors.push('city_id or city_name cant be blank') if city_id_or_city_name.blank?
    end

    def city_id_or_city_name
      @params[:city_id]&.to_i || @params[:city_name]
    end

    def current_temperature
      return if @errors.present?

      result = @weather_api.current(city_id_or_city_name)
      @condictions = result.weather_conditions.description
      @temperature = result.weather_conditions.temperature
      @city_name = result.city.name
    end

    def forecast_temperature
      return if @errors.present?

      result = @weather_api.forecast(city_id_or_city_name)
      preditions = {}

      result.forecast.each do |forecast|
        key = forecast.time.strftime('%d/%m')
        next if key == Date.today.strftime('%d/%m')

        preditions[key] = (preditions[key] || []).push(forecast.temperature)
      end

      forecast_average(preditions)
    end

    def forecast_average(preditions)
      preditions.each_key do |str_date|
        @average_temperature[str_date] = (preditions[str_date].sum / preditions[str_date].size.to_f).round(2)
      end
    end

    def mount_text
      return if @errors.present?

      @tweet_text = "#{@temperature}#{human_unit} e #{@condictions} "
      @tweet_text += "em #{@city_name} em #{Date.today.strftime('%d/%m')}. "
      @tweet_text += 'Média para os próximos dias: '

      average_text = []
      @average_temperature.each_key do |str_date|
        average_text.push("#{@average_temperature[str_date]}#{human_unit} em #{str_date}")
      end

      @tweet_text += "#{average_text.join(', ')}."
      @tweet_text
    end

    def human_unit
      @unit == 'metric' ? '°C' : '°F'
    end
  end
end
