json.extract! feed, :id, :url, :name, :active, :created_at, :updated_at
json.url feed_url(feed, format: :json)
