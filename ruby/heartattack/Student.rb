require_relative 'Initial'
require_relative 'Person'

class Student < Person
	Attributes = 'metabolism beauty intelligence'.split

	attr :metabolism
	attr :beauty
	attr :intelligence

	def initialize
		super
		@metabolism = Initial::Attribute
		@beauty = Initial::Attribute
		@intelligence = Initial::Attribute
	end
end
