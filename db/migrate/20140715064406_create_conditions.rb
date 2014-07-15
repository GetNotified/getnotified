class CreateConditions < ActiveRecord::Migration
  def change
    create_table :conditions do |t|
      t.string :name
      t.text :description
      t.string :type
      t.string :html_control
      t.boolean :required
      t.string :values

      t.timestamps
    end
  end
end
