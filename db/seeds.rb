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

url = "http://data.cityofchicago.org/resource/4ijn-s7e5.json"
json = open(url).read
inspections = JSON.parse(json)

inspections.each do |inspection|

	business = Business.find_by("address = ? AND dba_name = ?", inspection["address"], inspection["dba_name"])

	if business.nil?
		business = Business.new
		business.dba_name = inspection["dba_name"]
		business.aka_name = inspection["aka_name"]
		business.license = inspection["license_"].to_i
		business.facility_type = inspection["facility_type"]
		business.address = inspection["address"]
		business.zip = inspection["zip"].to_i
		business.latitude = inspection["latitude"].to_f
		business.longitude = inspection["longitude"].to_f
		business.save

		puts "New Business: " + business.dba_name + " " + business.address
	end

	new_inspection = Inspection.new
	new_inspection.inspect_id = inspection["inspection_id"].to_i
	new_inspection.inspect_date = inspection["inspection_date"]
	new_inspection.inspect_type = inspection["inspection_type"]
	new_inspection.results = inspection["results"]
	new_inspection.violations = inspection["violations"]
	new_inspection.business_id = business.id
	new_inspection.save

	puts "New Inspection: " + new_inspection.inspect_id.to_s
end
