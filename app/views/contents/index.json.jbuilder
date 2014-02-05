json.array!(@contents) do |content|
  json.extract! content, :id, :name, :url
  json.url content_url(content, format: :json)
end
