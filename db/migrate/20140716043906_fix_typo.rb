class FixTypo < ActiveRecord::Migration
  def change
    rename_column :services, :accout_required, :account_required
  end
end
