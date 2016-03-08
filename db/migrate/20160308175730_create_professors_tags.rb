class CreateProfessorsTags < ActiveRecord::Migration
  def up
    create_table :professors_tags do |t|
      t.integer :professor_id
      t.integer :tag_id
      t.timestamps
    end
  end

  def down
    drop_table :professors_tags
  end
end
