class AddOrganizationToScores < ActiveRecord::Migration
  def change
    add_column :scores, :organization, :decimal
  end
end
