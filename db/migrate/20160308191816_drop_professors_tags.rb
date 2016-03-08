class DropProfessorsTags < ActiveRecord::Migration
  def change
    drop_table :professors_tags
  end
end
