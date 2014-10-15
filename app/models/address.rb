class Address < ActiveRecord::Base

	before_save :validate_address

	belongs_to :business

	def validate_address
		if !self.address.nil? && self.address.include?("-")
			address_components = self.address.split(" ")
			street_nums = address_components[0].split("-")

			begin_street_num = street_nums[0].to_i
			end_street_num = street_nums[1].to_i

			while begin_street_num <= end_street_num
				#form address
				address = Address.new
				address.address = begin_street_num.to_s + reform_address(address_components[1..-1])
				address.zip = self.zip
				address.latitude = self.latitude
				address.longitude = self.longitude
				address.business_id = self.business_id
				address.save

				begin_street_num += 2
			end
		end
	end

	def reform_address(address_comps)
		address = ""

		address_comps.each do |comp|
			address = address + " " + comp
		end

		return address
	end
end

