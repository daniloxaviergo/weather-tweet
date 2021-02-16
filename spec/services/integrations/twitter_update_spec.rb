require 'rails_helper'

describe Integrations::TwitterUpdate, type: :service do
  let(:params) { { city_id: 3_398_904 } }

  describe '#execute' do
    context 'on success' do
      before do
        OpenWeatherMapMock::Endpoints.current_by_city_id(params[:city_id])
        OpenWeatherMapMock::Endpoints.forecast_by_city_id(params[:city_id])

        text_tweet = ::Integrations::OpenWeatherMap.new(params).execute
        TwitterUpdateMock::Endpoints.update(text_tweet)
      end

      it 'expected creates a tweet' do
        service = described_class.new(params)
        status, tweet = service.execute

        expect(status).to be_truthy
        expect(tweet).to be_present
        expect(tweet.id).to eq(1_050_118_621_198_921_700)
      end
    end

    context 'on error' do
      before do
        OpenWeatherMapMock::Endpoints.current_by_city_id_error(params[:city_id])
      end

      it 'return errors' do
        service = described_class.new(params)
        status, errors = service.execute

        expect(status).to be_falsey
        expect(errors.count).to eq(1)
        expect(errors.join).to eq("error while parsing data : 765: unexpected token at ''")
      end
    end
  end
end
