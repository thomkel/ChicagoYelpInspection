class Inspection < ActiveRecord::Base

	validates :inspect_id, :uniqueness => true
	validates :business_id, :presence => true	

	belongs_to :business
end
