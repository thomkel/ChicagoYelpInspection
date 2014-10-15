class RemoveAddressFromBusiness < ActiveRecord::Migration
  def change
    remove_column :businesses, :address, :string
    remove_column :businesses, :zip, :integer
    remove_column :businesses, :latitude, :float
    remove_column :businesses, :longitude, :float
  end
end
