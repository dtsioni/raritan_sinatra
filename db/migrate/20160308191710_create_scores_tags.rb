class CreateScoresTags < ActiveRecord::Migration
  def up
    create_table :scores_tags do |t|
      t.integer :score_id
      t.integer :tag_id
      t.timestamps
    end
  end

  def down
    drop_table :scores_tags
  end
end

