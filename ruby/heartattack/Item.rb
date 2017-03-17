
class Item

	Endings = {}
	Endings['y'] = 'ies'

	attr_accessor :number

	def initialize(number=1)
		@number = number
	end
	def to_s
		if @number > 1
			return "#{@number} #{plural}"
		else
			return name
		end
	end

	def name
		return type.to_s.downcase
	end

	# Attempt to intelligently determine plural of Name.
	def plural
		Endings.each { |k, v|
			if name =~ '(.*)' + k + '$'
				return $1.to_s + v
			end
		}
		return "#{name}s"
	end

	def <=>(other)
		return self.name <=> other.name
	end
end


# Some example items.

class Flower < Item
end

class Tulip < Flower
end

class Bread < Item
	def plural; 'pieces of bread' end
end
