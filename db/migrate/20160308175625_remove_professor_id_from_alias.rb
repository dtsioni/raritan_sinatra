class RemoveProfessorIdFromAlias < ActiveRecord::Migration
  def change
    remove_column :aliases, :professor_id, :integer
  end
end
