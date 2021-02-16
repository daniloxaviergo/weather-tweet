module Integrations
  class TwitterUpdate
    def initialize(params)
      @params = params
    end

    def execute
      weather_map = ::Integrations::OpenWeatherMap.new(@params)
      text_tweet = weather_map.execute

      return [false, weather_map.errors] if weather_map.errors.present?

      [true, twitter_client.update(text_tweet)]
    end

    private

    def twitter_client
      return @twitter_client if @twitter_client.present?

      @twitter_client = ::Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV.fetch('TWITTER_CONSUMER_KEY')
        config.consumer_secret     = ENV.fetch('TWITTER_CONSUMER_SECRET')
        config.access_token        = ENV.fetch('TWITTER_ACCESS_TOKEN')
        config.access_token_secret = ENV.fetch('TWITTER_ACCESS_TOKEN_SECRET')
      end
    end
  end
end
