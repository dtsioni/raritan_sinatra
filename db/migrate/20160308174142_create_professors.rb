class CreateProfessors < ActiveRecord::Migration
  def up
    create_table :professors do |t|
      t.timestamps
    end
  end

  def down
    drop_table :professors
  end
end
