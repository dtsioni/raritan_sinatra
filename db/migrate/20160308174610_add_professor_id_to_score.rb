class AddProfessorIdToScore < ActiveRecord::Migration
  def change
    add_column :scores, :professor_id, :integer
  end
end
