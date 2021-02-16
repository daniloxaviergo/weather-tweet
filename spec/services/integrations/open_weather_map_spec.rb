require 'rails_helper'

describe Integrations::OpenWeatherMap, type: :service do
  let(:params) { { city_id: 3_398_904 } }

  describe '#execute' do
    context 'on success' do
      before do
        OpenWeatherMapMock::Endpoints.current_by_city_id(params[:city_id])
        OpenWeatherMapMock::Endpoints.forecast_by_city_id(params[:city_id])
      end

      it 'return expected text' do
        service = described_class.new(params)
        service.execute

        str_date = Date.today.strftime('%d/%m')
        expect(service.tweet_text).to eq("282.55°C e clear sky em Mountain View em #{str_date}. Média para os próximos dias: 63.76°C em 10/09, 59.18°C em 11/09.")
        expect(service.errors).to be_blank
      end
    end

    context 'on error' do
      before do
        OpenWeatherMapMock::Endpoints.current_by_city_id_error(params[:city_id])
      end

      it 'empty text weather' do
        service = described_class.new(params)
        service.execute

        expect(service.tweet_text).to be_blank
        expect(service.errors).to be_present
      end
    end
  end
end
