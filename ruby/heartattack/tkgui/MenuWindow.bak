
require 'GUI'
require 'Menu'

class MenuWindow < TkFrame

	Title = 'Menu'
	
	def initialize(parent)
		super(parent)

		@callback = proc { |v|
			puts 'Callback undefined for option: ' + v
		}
	end

	def setCallback(callback)
		@callback = callback
	end

	def load(menu)
		@menu = menu
		@menuFrame.unpack if @menuFrame
		@menuFrame = TkFrame.new(self)
		@menuFrame.fill 'both'
		@menuFrame.expand true
		@menuFrame.side 'top'
		title = TkLabel.new(@menuFrame)
		title.text menu.name
		title.side 'top'
		title.anchor 'nw'
		title.pack
		addMenu(menu)
		@menuFrame.pack
	end

	def addMenu(menu)
		menu.each { |o|
			addButton(o)
		}
	end

	def addButton(item)
		b = TkButton.new(@menuFrame)
		b.text item.to_s
		b.borderwidth 1
		b.command proc {
			callback item
		}
		b.fill 'x'
		b.anchor 'nw'
		b.pack
	end

	def callback(option)
		if option.type == Menu
			load(option)
			addButton('Back...')
		elsif option == 'Back...'
			load(@menu.parent)
		else
			@callback.call(option)
		end
	end
end
