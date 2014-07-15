json.array!(@notification_types) do |notification_type|
  json.extract! notification_type, :id, :name, :description, :service_id, :account_required, :condition_id, :featured, :public
  json.url notification_type_url(notification_type, format: :json)
end
