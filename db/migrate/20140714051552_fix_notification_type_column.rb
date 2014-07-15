class FixNotificationTypeColumn < ActiveRecord::Migration
  def up
    rename_column :notifications, :type, :notif_type
    change_column :notifications, :notif_type, :string, after: :service_id
  end

  def down
    rename_column :notifications, :notif_type, :type
  end
end