require_relative 'Initial'
require_relative 'Student'

class You < Student
	attr :health
	attr :style
	attr :studiousness
	attr :job
	attr :promotions
	attr :money

	def initialize
		super
		@money = Initial::Money
		notifyObservers
	end
end
