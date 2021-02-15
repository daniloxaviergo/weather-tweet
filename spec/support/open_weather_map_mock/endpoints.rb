module OpenWeatherMapMock
  class Endpoints
    extend WebMock::API

    def self.body_json(file_name = nil)
      return File.read(File.join(File.dirname(__FILE__), "./#{file_name}.json")) if file_name.present?

      method_caller = caller_locations.first
      json_name = method_caller.label

      File.read(File.join(File.dirname(__FILE__), "./#{json_name}.json"))
    end

    def self.current_by_city_id(city_id)
      stub_request(:get, "https://api.openweathermap.org//data/2.5/weather?apikey=#{ENV.fetch('OPEN_WEATHER_API_KEY')}&id=#{city_id}&lang=en&units=metric")
        .to_return(status: 200, body: body_json, headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'api.openweathermap.org', 'User-Agent' => 'Ruby' })
    end

    def self.current_by_city_id_error(city_id)
      stub_request(:get, "https://api.openweathermap.org//data/2.5/weather?apikey=#{ENV.fetch('OPEN_WEATHER_API_KEY')}&id=#{city_id}&lang=en&units=metric")
        .to_return(status: 500, body: nil, headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'api.openweathermap.org', 'User-Agent' => 'Ruby' })
    end

    def self.forecast_by_city_id(city_id)
      stub_request(:get, "https://api.openweathermap.org//data/2.5/forecast?apikey=#{ENV.fetch('OPEN_WEATHER_API_KEY')}&id=#{city_id}&lang=en&units=metric")
        .to_return(status: 200, body: body_json, headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'api.openweathermap.org', 'User-Agent' => 'Ruby' })
    end
  end
end
