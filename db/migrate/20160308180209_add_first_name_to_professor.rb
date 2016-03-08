class AddFirstNameToProfessor < ActiveRecord::Migration
  def change
    add_column :professors, :first_name, :string
  end
end
