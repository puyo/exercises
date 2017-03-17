require_relative 'Person'

class Sexuality
	Heterosexual = 0
	Homosexual = 1
	Bisexual = 2
end

class Friend < Student
	attr :random
	def initialize
		super
		@sexuality = Sexuality::Heterosexual
		@loyalty = 0
		@random = false
	end
	def Friend.newRandom
		f = Friend.new
		f.random = true
		return f
	end
	def to_s
		if @name == nil 
			if @random == false 
				return 'Custom Friend'
			else 
				return 'Random Friend'
			end
		else
			return @name
		end
	end
end
