json.extract! micropost, :id, :content, :created_at, :updated_at
json.url micropost_url(micropost, format: :json)
