class AddConditionToNotificationType < ActiveRecord::Migration
  def change
    add_reference :conditions, :notification_type, index: true
  end
end
