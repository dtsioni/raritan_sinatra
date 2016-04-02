class RemoveOldMetrics < ActiveRecord::Migration
  def change
    remove_column :scores, :fairness, :decimal
    remove_column :scores, :homework, :decimal
    remove_column :scores, :preparation, :decimal
    remove_column :scores, :attendance, :decimal
    remove_column :scores, :participation, :decimal
  end
end
