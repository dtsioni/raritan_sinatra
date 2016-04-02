class AddNewMetrics < ActiveRecord::Migration
  def change
    add_column :scores, :easiness, :decimal
  end
end
