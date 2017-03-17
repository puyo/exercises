require 'GUI'

SIGNAL_NEW = GUI::newSignal
SIGNAL_LOAD = GUI::newSignal

class StartFrame < GUI::VerticalFrame
	include GUI

	def initialize(parent)
		super(parent)

		setPad(5)

		setVSpacing(5)

		b = Button.new(self, "&New Game")
		b.setLayoutHints(LAYOUT_FILL_X)
		b.connect(SIGNAL_COMMAND) { emit(SIGNAL_NEW) }
		b = Button.new(self, "&Load Saved Game")
		b.setLayoutHints(LAYOUT_FILL_X)
		b.connect(SIGNAL_COMMAND) { emit(SIGNAL_LOAD) }
		#b = Button.new(self, '&Quit', nil, parent, parent.type::ID_CANCEL)
		#b.setLayoutHints(LAYOUT_FILL_X)
	end
end

class StartWindow < GUI::DialogBox
	include GUI
	
	Title = 'Heart Attack'

	def initialize(parent)
		super(parent, Title)
		StartFrame.new(self)
	end
end
