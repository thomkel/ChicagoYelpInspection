# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'json'

Business.destroy_all
Inspection.destroy_all

json = File.read('db/inspections.json')
json_data = JSON.parse(json)
inspections = json_data["data"]

inspections.each do |inspection|
	inspect_id = inspection[8]
	dba_name = inspection[9]
	aka_name = inspection[10]
	license = inspection[11]
	facility_type = inspection[12]
	address = inspection[14]
	zip = inspection[17]
	inspect_date = inspection[18]
	inspect_type = inspection[19]
	results = inspection[20]
	violations = inspection[21]
	latitude = inspection[22]
	longitude = inspection[23]

	business = Business.find_by("address = ? AND aka_name = ?", address, aka_name)

	if business.nil?
		business = Business.new
		business.dba_name = dba_name
		business.aka_name = aka_name
		business.license = license.to_i
		business.facility_type = facility_type
		business.address = address
		business.zip = zip.to_i
		business.latitude = latitude.to_f
		business.longitude = longitude.to_f
		business.save

		puts "New Business: " + business.dba_name + " " + business.address
	end

	new_inspection = Inspection.new
	new_inspection.inspect_id = inspect_id.to_i
	new_inspection.inspect_date = inspect_date
	new_inspection.inspect_type = inspect_type
	new_inspection.results = results
	new_inspection.violations = violations
	new_inspection.business_id = business.id
	new_inspection.save

	puts "New Inspection: " + new_inspection.inspect_id.to_s
end
