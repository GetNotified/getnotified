class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, index: true
      t.references :service, index: true
      t.string :type
      t.hstore :conditions

      t.timestamps
    end
  end
end
