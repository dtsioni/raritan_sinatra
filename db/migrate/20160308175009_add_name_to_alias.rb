class AddNameToAlias < ActiveRecord::Migration
  def change
    add_column :aliases, :name, :string
  end
end
