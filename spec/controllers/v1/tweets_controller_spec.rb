require 'rails_helper'

describe V1::TweetsController, type: :controller do
  let(:params) { { city_id: 3_398_904 } }

  describe '#create' do
    subject { post :create, params: params }

    context 'when request is successfully' do
      before do
        ::OpenWeatherMapMock::Endpoints.current_by_city_id(params[:city_id])
        ::OpenWeatherMapMock::Endpoints.forecast_by_city_id(params[:city_id])

        text_tweet = ::Integrations::OpenWeatherMap.new(params).execute
        ::TwitterUpdateMock::Endpoints.update(text_tweet)
      end

      it 'expect return success http status' do
        expect(subject).to have_http_status(:ok)
      end
    end

    context 'when request is unsuccessfully' do
      before do
        OpenWeatherMapMock::Endpoints.current_by_city_id_error(params[:city_id])
      end

      it 'expect return unprocessable entity http status' do
        expect(subject).to have_http_status(:unprocessable_entity)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response.count).to eq(1)
        expect(parsed_response.join).to eq("error while parsing data : 765: unexpected token at ''")
      end
    end
  end
end
