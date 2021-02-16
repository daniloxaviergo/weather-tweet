module V1
  class TweetsController < ApplicationController
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
