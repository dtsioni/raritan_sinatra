class ChangeScoreDecimalsToFloats < ActiveRecord::Migration
  def change
    change_column :scores, :fairness, :float
    change_column :scores, :clarity, :float
    change_column :scores, :helpfulness, :float
    change_column :scores, :preparation, :float
    change_column :scores, :homework, :float
    change_column :scores, :interesting, :float
  end
end
