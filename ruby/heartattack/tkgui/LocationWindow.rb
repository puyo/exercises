
require 'GUI'

class LocationWindow < TkFrame

	def initialize(parent)
		super(parent)
		@locationName = TkVariable.new
		@locationName.value = '(Location)'
		heading = TkLabel.new(self)
		heading.textvariable @locationName
		heading.side 'top'
		heading.anchor 'nw'
		heading.pack
		clear
	end

	def clear
		@contents.unpack if @contents
		@contents = TkFrame.new(self)
		@contents.fill 'both'
		@contents.expand true
		@contents.pack('padx'=>10,'pady'=>10)
	end

	def setLocation(location)
		@location = location
		@locationName.value = @location.name

		# Set the picture
		clear
		@picture = TkLabel.new(@contents)
		@picture.relief 'solid'
		@picture.borderwidth 1
		if @location.picture
			@picture.image @location.picture
			@picture.side 'top'
			@picture.anchor 'nw'
			@picture.fill 'both'
			@picture.expand true
		else
			@picture.text '(No Image)'
			@picture.fill 'both'
			@picture.expand true
		end
		@picture.pack
	end
end
