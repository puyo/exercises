require 'GUI'

class MainWindowPane < GUI::VerticalFrame
	include GUI
	def initialize(parent, title, *args)
		super(parent, *args)
		setLayoutHints(LAYOUT_FILL_BOTH)
		setFrameStyle(FRAME_SUNKEN | FRAME_THICK)
#		setBackColor(0x804040) # dark grey-blue
		setBackColor(0x3140cd)
#		setBackColor(0xc9e0ef)
#		setBackColor(0xdcdcdc)
#		setBackColor(0x000084)
		setPad(0)
		title = Label.new(self, title)
		title.setBackColor(0x39baf6)

		title.setTextColor(0x000000)
		title.setFrameStyle(FRAME_RAISED | FRAME_THICK)
		title.setLayoutHints(LAYOUT_FILL_X)
		title.setJustify(JUSTIFY_LEFT)
	end
end

class MainWindow < GUI::MainWindow
	include GUI

	def initialize(app, title)
		super(app, title)

		setWidth(640)
		setHeight(480)

		# Menus

		# File
		menuFile = MenuPane.new(self)
		commandOpen = MenuCommand.new(menuFile, "&Open...\tCtrl-O\tOpen a file.")
		commandOpen.connect(SIGNAL_COMMAND) {
			puts 'Open...'
		}
		commandNext = MenuCommand.new(menuFile, "&Next...\tCtrl-N\tNext screen.")
		commandNext.connect(SIGNAL_COMMAND) {
			emit(SIGNAL_NEXT)
		}
		MenuSeparator.new(menuFile)
		commandQuit = MenuCommand.new(menuFile, "&Quit\tCtrl-Q\tExit the program.")
		commandQuit.connect(SIGNAL_COMMAND) {
			getApp.quit
		}

		# Help
		menuHelp = MenuPane.new(self)
		commandAbout = MenuCommand.new(menuHelp, "&About\t\tAll about us...")
		commandAbout.connect(SIGNAL_COMMAND) {
			puts HeartAttack::About
		}

		# Add menu titles across menu bar
		menubar = Menubar.new(self, LAYOUT_SIDE_TOP|LAYOUT_FILL_X)
		menubar.setFrameStyle(FRAME_RAISED)
		file = MenuTitle.new(menubar, "&File\t\tFile system related options.", nil, menuFile)
		help = MenuTitle.new(menubar, "&Help\t\tHelp and information.", nil, menuHelp)
		help.setLayoutHints(LAYOUT_RIGHT)

		# Body of window

		body = VerticalFrame.new(self)
		body.setLayoutHints(LAYOUT_FILL_BOTH)
		body.setPad(5)
		body.setVSpacing(0)
		top = HorizontalFrame.new(body)
		top.setLayoutHints(LAYOUT_FILL_BOTH)
		top.setHSpacing(10)
		bottom = HorizontalFrame.new(body)
		bottom.setLayoutHints(LAYOUT_FILL_BOTH)
		bottom.setHSpacing(10)

		locationFrame = MainWindowPane.new(top, 'Location')
		peopleFrame = MainWindowPane.new(top, 'People')
		optionsFrame = MainWindowPane.new(top, "Options")

		logFrame = MainWindowPane.new(bottom, 'Log')
		statsFrame = MainWindowPane.new(bottom, 'You')

		b = Button.new(locationFrame, "&Stuff\tDoes Stuff\tDo stuff")

		status = StatusBar.new(body, LAYOUT_FILL_X|STATUSBAR_WITH_DRAGCORNER)
	end
end
