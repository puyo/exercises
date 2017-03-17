
require 'GUI'

class PeopleWindow < TkFrame

	Title = 'People'
	
	def initialize(parent)
		super(parent)
		heading = TkLabel.new(self)
		heading.text Title
		heading.side 'top'
		heading.anchor 'nw'
		heading.pack
	end
end
