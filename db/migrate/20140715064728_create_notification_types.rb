class CreateNotificationTypes < ActiveRecord::Migration
  def change
    create_table :notification_types do |t|
      t.string :name
      t.text :description
      t.references :service, index: true
      t.string :account_required
      t.references :condition, index: true
      t.boolean :featured
      t.boolean :public

      t.timestamps
    end
  end
end
