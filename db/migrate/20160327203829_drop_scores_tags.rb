class DropScoresTags < ActiveRecord::Migration
  def change
    drop_table :scores_tags
  end
end
