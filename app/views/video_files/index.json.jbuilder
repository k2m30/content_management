json.array!(@video_files) do |video_file|
  json.extract! video_file, :id, :internal_name, :internal_url, :external_name, :external_url, :quality, :year, :size
  json.url video_file_url(video_file, format: :json)
end
