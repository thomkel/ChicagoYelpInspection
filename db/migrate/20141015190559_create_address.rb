class CreateAddress < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :business_id
      t.string :address
      t.integer :zip
      t.float :latitude
      t.float :longitude
    end
  end
end
