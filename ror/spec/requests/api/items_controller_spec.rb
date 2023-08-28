require 'rails_helper'

RSpec.describe Api::ItemsController, type: :request do
  describe 'GET #index' do
    it 'returns a list of items as JSON' do
      items = create_list(:item, 3)

      get '/api/items'

      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['success']).to eq(1)
      expect(parsed_response['records'].length).to eq(3)
    end

    it 'returns items ordered by published_at in descending order' do
      items = create_list(:item, 3, published_at: Time.now - 1.day)
      items_published_at = items.map { |item| item.published_at.to_i }

      get '/api/items'

      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['records'].map { |item| item['published_at'] }).to eq(items_published_at.sort.reverse)
    end

    it 'filters items by selected feed_ids' do
      feed1 = create(:feed)
      feed2 = create(:feed)
      item1 = create(:item, feed: feed1)
      item2 = create(:item, feed: feed2)

      get '/api/items', params: { feed_ids: [feed1.id] }

      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['records'].length).to eq(1)
      expect(parsed_response['records'][0]['feed_id']).to eq(feed1.id)
    end

    it 'returns items ordered by published_at in ascending order if order_by param is "asc"' do
      items = create_list(:item, 3, published_at: Time.now - 1.day)
      items_published_at = items.map { |item| item.published_at.to_i }

      get '/api/items', params: { order_by: 'asc' }

      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['records'].map { |item| item['published_at'] }).to eq(items_published_at.sort)
    end
  end
end
