
require 'GUI'

class RootWindow < TkRoot

	RatioOfScreen = 0.7

	attr :contents

	def initialize
		@path = '.'
		sw = TkWinfo.screenwidth(self)
		sh = TkWinfo.screenheight(self)
		width = (sw*RatioOfScreen).to_i
		height = (sh*RatioOfScreen).to_i
		x = (sw - width)/2
		y = (sh - height)/2
		geometry "#{width}x#{height}+#{x}+#{y}"

		title HeartAttack::Title

		# Add a frame to contain the menus.
		menubar = TkFrame.new(self)
		menubar.relief 'raised'
		menubar.borderwidth 1
		menubar.side 'top'
		menubar.fill 'x'
		menubar.pack

		# Add the menus.
		m = menubar.addMenu('File')
		addCommand(m, 'New', 0, 'Ctrl+N', 'Control-Key-n')
		addCommand(m, 'Save', 0, 'Ctrl+S', 'Control-Key-s')
		addCommand(m, 'Load', 0, 'Ctrl+L', 'Control-Key-l')
		m.addSeparator
		addCommand(m, 'Exit', 1, 'Ctrl+X', 'Control-Key-x')

		m = menubar.addMenu('Help', 0, 'right')
		addCommand(m, 'About')

		@menuCallback = proc { |v|
			puts 'Callback undefined for menu option: ' + v
		}

		clear
	end

	def clear
		@contents.unpack if @contents
		@contents = TkFrame.new(self)
		@contents.fill 'both'
		@contents.expand true
		@contents.pack
	end

	def setMenuHandler(menuCallback)
		@menuCallback = menuCallback
	end

	private

	def addCommand(menu, label, underline=0, accelerator=nil, tkkey=nil)
		menu.addCommand 'label' => label,
			'underline' => underline,
			'command' => proc { @menuCallback.call(label) },
			'accelerator' => accelerator,
			'tkkey' => tkkey
	end
end
