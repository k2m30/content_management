json.array!(@sites) do |site|
  json.extract! site, :id, :name, :css, :banner
  json.url site_url(site, format: :json)
end
