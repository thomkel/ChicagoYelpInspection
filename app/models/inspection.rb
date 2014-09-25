class Inspection < ActiveRecord::Base

	validates :inspect_id, :uniqueness => true

	belongs_to :business
end
