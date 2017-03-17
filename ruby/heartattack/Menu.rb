
class Menu < Array
	attr_accessor :name
	attr_accessor :parent
	def initialize(name, parent=nil)
		@name = name
		@parent = parent
		super()
	end

	def to_s
		@name + '...'
	end
end

