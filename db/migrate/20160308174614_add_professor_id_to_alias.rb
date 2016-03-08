class AddProfessorIdToAlias < ActiveRecord::Migration
  def change
    add_column :aliases, :professor_id, :integer
  end
end
