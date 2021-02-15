# weather-tweet

docker build . -t rails-weather-tweet
docker container run --rm -it -v "$(pwd)":/usr/src/app rails-weather-tweet bash

docker container run -p 3000:3000 --rm -it -v "$(pwd)":/usr/src/app rails-weather-tweet bundle exec rails server -b 0.0.0.0 -p 3000

