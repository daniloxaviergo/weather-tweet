# weather-tweet

Comandos para montar o ambiente

```
git clone git@github.com:daniloxaviergo/weather-tweet.git
cd weather-tweet
cp .env.sample .env
```

Defina as variáveis(.env) das integrações openweathermap e twitter
```
OPEN_WEATHER_API_KEY=????
TWITTER_CONSUMER_KEY=????
TWITTER_CONSUMER_SECRET=????
TWITTER_ACCESS_TOKEN=????
TWITTER_ACCESS_TOKEN_SECRET=????
```

Para montar a imagem do docker e subir o rails na porta 3000
```
docker build . -t rails-weather-tweet
docker container run -p 3000:3000 --rm -it -v "$(pwd)":/usr/src/app rails-weather-tweet bundle exec rails server -b 0.0.0.0 -p 3000
```

Para acessar o bash do docker
```
docker container run --rm -it -v "$(pwd)":/usr/src/app rails-weather-tweet bash
```

Exemplo de requisição:
```
curl -d '{"city_id":"3398904", "lang":"ja", "unit":"imperial"}' \
  -H "Content-Type: application/json" \
  -X POST https://dxs-weather-tweet.herokuapp.com/v1/tweets

curl -d '{"city_id":"3398904", "lang":"pt"}' \
  -H "Content-Type: application/json" \
  -X POST http://localhost:3000/v1/tweets
```
