class AddWorkToScores < ActiveRecord::Migration
  def change
    add_column :scores, :work, :decimal
  end
end
