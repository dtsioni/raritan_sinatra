class AddProfessorIdToTag < ActiveRecord::Migration
  def change
    add_column :tags, :professor_id, :integer
  end
end
