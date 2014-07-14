json.array!(@notifications) do |notification|
  json.extract! notification, :id, :user_id, :service_id, :type, :conditions
  json.url notification_url(notification, format: :json)
end
