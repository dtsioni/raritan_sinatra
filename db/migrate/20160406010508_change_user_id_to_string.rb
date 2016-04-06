class ChangeUserIdToString < ActiveRecord::Migration
  def change
    change_column :scores, :user_id, :string
  end
end
