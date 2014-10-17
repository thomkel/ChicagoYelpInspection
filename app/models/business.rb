class Business < ActiveRecord::Base

	validates :aka_name, :uniqueness => {:scope => [:dba_name]}
	validates :license, :uniqueness => true
	before_save :validate_aka_name

	has_many :inspections
	has_many :addresses

	def validate_aka_name
		if self.aka_name.nil?
			self.aka_name = self.dba_name
		end
	end

end

