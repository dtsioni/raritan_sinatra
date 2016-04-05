class ChangeScoreDecimalsToFloats < ActiveRecord::Migration
  def change
    change_column :scores, :easiness, :float
    change_column :scores, :clarity, :float
    change_column :scores, :helpfulness, :float
    change_column :scores, :organization, :float
    change_column :scores, :work, :float
    change_column :scores, :interesting, :float
    change_column :scores, :pacing, :float
  end
end
