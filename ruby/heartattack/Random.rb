
def random(min, max)
	return rand(max - min + 1) + min
end

def rollDice(string)
	string =~ /([0-9]+)[dD]([0-9]+)/
	num = $1.to_i
	sides = $2.to_i
	result = 0
	(1..num).each {
		result += random(1, sides)
	}
	return result
end
