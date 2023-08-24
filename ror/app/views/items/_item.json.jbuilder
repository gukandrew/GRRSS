json.extract! item, :id, :title, :source, :source_url, :link, :published_at, :description, :feed_id, :created_at, :updated_at
json.url item_url(item, format: :json)
