
require 'GUI'

class LogWindow < TkFrame

	Title = 'Log'

	def initialize(parent)
		super(parent)
		heading = TkLabel.new(self)
		heading.text Title
		heading.anchor 'nw'
		heading.side 'top'
		heading.pack

		@box = TkScrollableTextBox.new(self)
		@box.fill 'both'
		@box.expand true
		@box.bg 'black'
		@box.pack

		clear
	end

	def log(message)
		@box.state 'normal'
		@messages << message
		@box.insert('end', message + "\n\n")
		@box.scrollTo(1.0)
		@box.state 'disabled'
	end

	def clear
		@messages = []
		@box.value = ''
	end
end
