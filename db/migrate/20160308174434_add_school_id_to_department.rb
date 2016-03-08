class AddSchoolIdToDepartment < ActiveRecord::Migration
  def change
    add_column :departments, :school_id, :integer
  end
end
