class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string :dba_name
      t.string :aka_name
      t.integer :license
      t.string :facility_type
      t.string :address
      t.integer :zip
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
