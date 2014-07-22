class RenameTypeColumn < ActiveRecord::Migration
  def change
    rename_column :conditions, :type, :input_type
  end
end
