# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'json'
require 'open-uri'

Business.destroy_all
Inspection.destroy_all
Address.destroy_all

url = "https://data.cityofchicago.org/api/views/4ijn-s7e5/rows.json"
json = open(url).read
json_data = JSON.parse(json)
inspections = json_data["data"]

inspections.each do |inspection|

	business = Business.find_by(:dba_name => inspection[9])

	if business.nil?
		business = Business.new
		business.dba_name = inspection[9]
		business.aka_name = inspection[10]
		business.license = inspection[11].to_i
		business.facility_type = inspection[12]
		business.save

		address = Address.new
		address.business_id = business.id
		address.address = inspection[14]
		address.zip = inspection[17].to_i
		address.latitude = inspection[22].to_f
		address.longitude = inspection[23].to_f
		address.save		

		puts "New Business: " + business.dba_name + " " + address.address
	end

	new_inspection = Inspection.new
	new_inspection.inspect_id = inspection[8].to_i
	new_inspection.inspect_date = inspection[18]
	new_inspection.inspect_type = inspection[19]
	new_inspection.results = inspection[20]
	new_inspection.violations = inspection[21]
	new_inspection.business_id = business.id
	new_inspection.save

	puts "New Inspection: " + new_inspection.inspect_id.to_s	
end
