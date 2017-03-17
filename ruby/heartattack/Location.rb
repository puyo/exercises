require_relative 'gui/GUI'

class Location

	LocationPictureDir = File.join('data', 'locations')

	attr :picture
	attr :name
	attr :people

	def initialize(name, pictureName=nil)
		@name = name
		@people = []
		if pictureName
			@picture = loadPicture(LocationPictureDir, pictureName)
		end
	end

	def addPeople(people)
		@people << people
	end
end
