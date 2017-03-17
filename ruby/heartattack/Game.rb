require_relative 'You'
require_relative 'Location'

class Game
	def Game.new
		puts "Game.new"
	end

	def Game.save
		puts "Game.save"
	end

	def Game.load(filename)
		puts "Game.load(#{filename})"
	end
end
