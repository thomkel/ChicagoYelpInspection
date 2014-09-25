class AddInspectTypeToInspection < ActiveRecord::Migration
  def change
    add_column :inspections, :inspect_type, :string
  end
end
