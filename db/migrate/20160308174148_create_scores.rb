class CreateScores < ActiveRecord::Migration
  def up
    create_table :scores do |t|
      t.timestamps
    end
  end

  def down
    drop_table :scores
  end
end
