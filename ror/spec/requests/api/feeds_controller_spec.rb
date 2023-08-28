require 'rails_helper'

RSpec.describe Api::FeedsController, type: :request do
  describe "GET /create_feeds" do
    it "triggers Bunny::UrlsTrigger and returns success JSON" do
      expect(Bunny::UrlsTrigger).to receive(:call)
      post '/api/feeds/import_feeds', params: { urls: "https://example.com\nhttp://another-example.com" }

      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['success']).to eq(1)
      expect(parsed_response['message']).to include("Feeds are being processed")
    end
  end

  describe "GET /index" do
    it "returns a list of feeds as JSON" do
      create_list(:feed, 3)

      get '/api/feeds'

      expect(response).to have_http_status(:success)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['success']).to eq(1)
      expect(parsed_response['records'].length).to eq(3)
    end
  end

  describe "PATCH #update" do
    it "updates a feed and returns success JSON" do
      feed = create(:feed)

      patch "/api/feeds/#{feed.id}", params: { feed: { name: 'New Name' } }

      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['success']).to eq(1)
      expect(feed.reload.name).to eq('New Name')
    end
  end

  describe "DELETE /destroy" do
    it "deletes a feed and returns success JSON" do
      feed = create(:feed)

      delete "/api/feeds/#{feed.id}"

      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['success']).to eq(1)
      expect { feed.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
