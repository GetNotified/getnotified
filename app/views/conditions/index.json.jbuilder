json.array!(@conditions) do |condition|
  json.extract! condition, :id, :name, :description, :type, :html_control, :required, :values
  json.url condition_url(condition, format: :json)
end
