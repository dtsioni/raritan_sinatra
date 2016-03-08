class CreateAliases < ActiveRecord::Migration
  def up
    create_table :aliases do |t|
      t.timestamps
    end
  end

  def down
    drop_table :aliases
  end
end
