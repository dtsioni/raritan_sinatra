class AddLastNameToProfessor < ActiveRecord::Migration
  def change
    add_column :professors, :last_name, :string
  end
end
