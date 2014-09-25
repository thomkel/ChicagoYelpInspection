class Business < ActiveRecord::Base

	validates :aka_name, :uniqueness => {:scope => [:dba_name, :address]}
	validates :license, :uniqueness => true

	has_many :inspections
end

