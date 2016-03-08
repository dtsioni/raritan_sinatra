class RemoveNameFromProfessor < ActiveRecord::Migration
  def change
    remove_column :professors, :name, :string
  end
end
