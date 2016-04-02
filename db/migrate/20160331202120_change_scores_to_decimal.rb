class ChangeScoresToDecimal < ActiveRecord::Migration
  def change
    change_column :scores, :fairness, :decimal
    change_column :scores, :clarity, :decimal
    change_column :scores, :helpfulness, :decimal
    change_column :scores, :preparation, :decimal
    change_column :scores, :homework, :decimal
    change_column :scores, :interesting, :decimal
  end
end
