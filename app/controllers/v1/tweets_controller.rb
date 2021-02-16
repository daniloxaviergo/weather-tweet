module V1
  class TweetsController < ApplicationController
    error 500, 'Server crashed for some reason.'
    error :unprocessable_entity, 'Could not creates the entity.'

    # rubocop:disable Layout/LineLength
    def_param_group :create do
      param :city_id, String, desc: 'City ID full list in (http://bulk.openweathermap.org/sample/city.list.json.gz) <br>Sample: 3462377, 3448433'
      param :city_name, String, desc: 'Name of city <br> Sample: Goiânia, São Paulo'
      param :lang, %w[ar bg ca cz de el en fa fi fr gl hr hu it ja kr la lt mk nl pl pt ro ru se sk sl es tr ua vi zh_cn zh_tw], desc: 'Arabic - ar<br> Bulgarian - bg<br>Catalan - ca<br>Czech - cz<br>German - de<br>Greek - el<br>English - en<br>Persian (Farsi) - fa<br>Finnish - fi<br>French - fr<br>Galician - gl<br>Croatian - hr<br>Hungarian - hu<br>Italian - it<br>Japanese - ja<br>Korean - kr<br>Latvian - la<br>Lithuanian - lt<br>Macedonian - mk<br>Dutch - nl<br>Polish - pl<br>Portuguese - pt<br>Romanian - ro<br>Russian - ru<br>Swedish - se<br>Slovak - sk<br>Slovenian - sl<br>Spanish - es<br>Turkish - tr<br>Ukrainian - ua<br>Vietnamese - vi<br>Chinese Simplified - zh_cn<br>Chinese Traditional - zh_tw<br>Ex. pt'
      param :unit, %w[metric imperial], desc: 'Unit system.<br> metric (temperatures in Celsius)<br>imperial (temperatures in Fahrenheit)'
    end

    api :POST, 'v1/tweets', 'Create a tweet'
    returns code: 200
    returns code: :unprocessable_entity, desc: 'Array of errors. [\'description of error\', \'error while parsing data : 765: unexpected token at \'\']'
    formats ['json']
    meta message: 'If you send city_id is not necessary city_name'
    example " curl -v -d '{\"city_id\":\"3462377\", \"lang\":\"pt\"}' -H \"Content-Type: application/json\" -X POST https://dxs-weather-tweet.herokuapp.com/v1/tweets"
    param_group :create
    # rubocop:enable Layout/LineLength
    def create
      status, errors = ::Integrations::TwitterUpdate.new(tweets_params).execute

      if status
        head :ok
      else
        render json: errors, status: :unprocessable_entity
      end
    end

    private

    def tweets_params
      params.permit(:city_id, :city_name, :lang, :unit)
    end
  end
end
