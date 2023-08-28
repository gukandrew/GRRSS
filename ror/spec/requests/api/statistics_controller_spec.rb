require 'rails_helper'

RSpec.describe Api::StatisticsController, type: :request do
  describe 'GET #index' do
    it 'returns feed and item counts as JSON' do
      create_list(:feed, 3)
      create_list(:item, 5)
      create_list(:item, 2, :with_feed)

      get '/api/statistics'

      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['success']).to eq(1)
      expect(parsed_response['feeds']).to eq(5)
      expect(parsed_response['items']).to eq(7)
    end
  end
end
