require_relative 'Game'
require_relative 'Random'
require_relative 'gui/GUI'
require_relative 'Signals'
require_relative 'gui/MainWindow'
require_relative 'gui/StartWindow'
require_relative 'gui/CreationWindows'

class HeartAttack < GUI::App
	Title = 'Heart Attack'
	About = 'A love simulation game by Lucy Ding and Gregory McIntyre.'
	Vendor = 'Puyo & Haju'

	BackgroundColour = 0x3838c4
	TextColour = 0xD0D0D0
	ColourScheme = {}
	ColourScheme.default = {}
	ColourScheme[:background] = {}
	ColourScheme[:background].default = BackgroundColour
	ColourScheme[:background][GUI::TextField] = TextColour
	ColourScheme[:background][GUI::Button] = TextColour
	ColourScheme[:foreground] = {}
	ColourScheme[:foreground].default = TextColour
	ColourScheme[:foreground][GUI::RadioButton] = BackgroundColour
	ColourScheme[:foreground][GUI::ArrowButton] = 0x000000
	ColourScheme[:text] = {}
	ColourScheme[:text].default = TextColour
	ColourScheme[:text][GUI::TextField] = BackgroundColour
	ColourScheme[:text][GUI::Button] = 0x000000
	ColourScheme[:highlight] = {}
	ColourScheme[:highlight].default = TextColour
	ColourScheme[:shadow] = {}
	ColourScheme[:shadow].default = GUI::Colours::Black
	ColourScheme[:base] = {}
	ColourScheme[:base].default = GUI::Colours::White
	ColourScheme[:background_selected] = {}
	ColourScheme[:background_selected].default = TextColour
	ColourScheme[:text_selected] = {}
	ColourScheme[:text_selected].default = BackgroundColour
end

SIGNAL_NEXT = GUI::newSignal

def start(app)
	app.stop
	app.mainWindow.show(GUI::PLACEMENT_SCREEN)
	app.run
end

def main
	puts 'Running...'

	app = HeartAttack.new
	app.init(ARGV)
	MainWindow.new(app, HeartAttack::Title)
	app.create

#	y = YouCreationWindow.new(app)
#	y.execute
#	exit

	s = StartWindow.new(app)
	s.connect(StartWindow::SIGNAL_NEW) {
		y = YouCreationWindow.new(app)
		y.execute
		Game.new
		start(app)
	}
	s.connect(StartWindow::SIGNAL_LOAD) {
		Game.load("dummy")
		start(app)
	}
	s.execute
end

main
