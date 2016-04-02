class AddPacingToScores < ActiveRecord::Migration
  def change
    add_column :scores, :pacing, :decimal
  end
end
