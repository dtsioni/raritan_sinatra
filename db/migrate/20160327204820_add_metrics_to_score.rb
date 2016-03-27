class AddMetricsToScore < ActiveRecord::Migration
  def change
    add_column :scores, :fairness, :integer
    add_column :scores, :clarity, :integer
    add_column :scores, :helpfulness, :integer

    add_column :scores, :preparation, :integer
    add_column :scores, :homework, :integer
    add_column :scores, :participation, :integer
    add_column :scores, :interesting, :integer
    add_column :scores, :attendance, :integer
  end
end
