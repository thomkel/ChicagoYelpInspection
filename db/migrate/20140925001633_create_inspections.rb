class CreateInspections < ActiveRecord::Migration
  def change
    create_table :inspections do |t|
      t.integer :inspect_id
      t.date :inspect_date
      t.string :results
      t.text :violations

      t.timestamps
    end
  end
end
