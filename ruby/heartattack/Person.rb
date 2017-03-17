require_relative 'Initial'
require_relative 'Model'
require_relative 'Inventory'

class Person < Model

	Genders = 'male female'.split
	Starsigns = 'Taurus Aries Cancer Capricorn Virgo Libra Gemini Aquarius Pisces Leo Saggitarius Scorpio'.split
	ValidName = Regexp.new('[^ ]+.*')

	attr :name
	attr :gender
	attr :birthday
	attr :starsign
	attr :inventory
	attr :relationships
	attr :picture

	def initialize
		@inventory = Inventory.new(self)
		@relationships = {}
	end
end

