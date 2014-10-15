class Business < ActiveRecord::Base

	validates :aka_name, :uniqueness => {:scope => [:dba_name]}
	validates :license, :uniqueness => true

	has_many :inspections
	has_many :addresses

end

