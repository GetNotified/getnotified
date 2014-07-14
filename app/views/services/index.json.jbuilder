json.array!(@services) do |service|
  json.extract! service, :id, :name, :description, :url
  json.url service_url(service, format: :json)
end
