class RemoveOldMetrics < ActiveRecord::Migration
  def change
    remove_column :scores, :fairness, :decimal
    remove_column :scores, :homework, :decimal
    remove_column :scores, :preparation, :decimal
  end
end
