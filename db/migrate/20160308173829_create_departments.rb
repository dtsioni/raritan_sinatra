class CreateDepartments < ActiveRecord::Migration
  def up
    create_table :departments do |t|
      t.string :name
      t.timestamps
    end
  end

  def down
    drop_table :departments
  end
end
