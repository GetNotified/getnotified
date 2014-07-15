class AddServiceColumns < ActiveRecord::Migration
  def change
    add_column :services, :logo_url, :string, after: :url
    add_reference :services, :notification_type, index: true, after: :logo_url
    add_column :services, :accout_required, :string, after: :notification_type_id
    add_column :services, :featured, :boolean, after: :accout_required
    add_column :services, :public, :boolean, after: :featured
  end
end
