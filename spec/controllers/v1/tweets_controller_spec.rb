require 'rails_helper'

describe V1::TweetsController, type: :controller do
  describe '#index' do
    subject { get :index }

    context 'when request is successfully' do
      it 'expect return success http status' do
        expect(subject).to have_http_status(:ok)
      end
    end
  end
end
