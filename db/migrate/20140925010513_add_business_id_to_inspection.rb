class AddBusinessIdToInspection < ActiveRecord::Migration
  def change
    add_column :inspections, :business_id, :integer
  end
end
