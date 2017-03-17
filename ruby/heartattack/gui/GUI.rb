require 'fox16'

# Add some global defs.
class Object
	def setPad(val)
		setPadTop(val)
		setPadBottom(val)
		setPadLeft(val)
		setPadRight(val)
	end

	def makeIcon(name, subdir='icons')
		$LOAD_PATH.each { |dir|
			path = File.join(dir, subdir, name) + '.*'
			filenames = Dir.glob(path)
			next if filenames.size == 0
			filename = filenames[0] # Use the first one.
			case filename
			when /\.png$/
				return Fox::FXPNGIcon.new(getApp, File.open(filename, "rb").read)
			when /\.jpg$/
				return Fox::FXJPGIcon.new(getApp, File.open(filename, "rb").read)
			when /\.gif$/
				return Fox::FXGIFIcon.new(getApp, File.open(filename, "rb").read)
			else
				puts 'Invalid icon file type: "' + filename.to_s + '"'
			end
		}
		puts 'Cound not find icon: ' + name
	end
end

module GUI

	include Fox

	# Signals

	LAYOUT_FILL_BOTH = LAYOUT_FILL_X | LAYOUT_FILL_Y
	LAYOUT_FIX_BOTH = LAYOUT_FIX_WIDTH | LAYOUT_FIX_HEIGHT

	SIGNAL_NONE = SEL_NONE
	SIGNAL_KEYPRESS = SEL_KEYPRESS
	SIGNAL_KEYRELEASE = SEL_KEYRELEASE
	SIGNAL_LEFTBUTTONPRESS = SEL_LEFTBUTTONPRESS
	SIGNAL_LEFTBUTTONRELEASE = SEL_LEFTBUTTONRELEASE
	SIGNAL_MIDDLEBUTTONPRESS = SEL_MIDDLEBUTTONPRESS
	SIGNAL_MIDDLEBUTTONRELEASE = SEL_MIDDLEBUTTONRELEASE
	SIGNAL_RIGHTBUTTONPRESS = SEL_RIGHTBUTTONPRESS
	SIGNAL_RIGHTBUTTONRELEASE = SEL_RIGHTBUTTONRELEASE
	SIGNAL_MOTION = SEL_MOTION
	SIGNAL_ENTER = SEL_ENTER
	SIGNAL_LEAVE = SEL_LEAVE
	SIGNAL_FOCUSIN = SEL_FOCUSIN
	SIGNAL_FOCUSOUT = SEL_FOCUSOUT
	SIGNAL_KEYMAP = SEL_KEYMAP
	SIGNAL_UNGRABBED = SEL_UNGRABBED
	SIGNAL_PAINT = SEL_PAINT
	SIGNAL_CREATE = SEL_CREATE
	SIGNAL_DESTROY = SEL_DESTROY
	SIGNAL_UNMAP = SEL_UNMAP
	SIGNAL_MAP = SEL_MAP
	SIGNAL_CONFIGURE = SEL_CONFIGURE
	SIGNAL_SELECTION_LOST = SEL_SELECTION_LOST
	SIGNAL_SELECTION_GAINED = SEL_SELECTION_GAINED
	SIGNAL_SELECTION_REQUEST = SEL_SELECTION_REQUEST
	SIGNAL_RAISED = SEL_RAISED
	SIGNAL_LOWERED = SEL_LOWERED
	SIGNAL_CLOSE = SEL_CLOSE
	#SIGNAL_CLOSEALL = SEL_CLOSEALL
	SIGNAL_DELETE = SEL_DELETE
	SIGNAL_MINIMIZE = SEL_MINIMIZE
	SIGNAL_RESTORE = SEL_RESTORE
	SIGNAL_MAXIMIZE = SEL_MAXIMIZE
	SIGNAL_UPDATE = SEL_UPDATE
	SIGNAL_COMMAND = SEL_COMMAND
	SIGNAL_CLICKED = SEL_CLICKED
	SIGNAL_DOUBLECLICKED = SEL_DOUBLECLICKED
	SIGNAL_TRIPLECLICKED = SEL_TRIPLECLICKED
	SIGNAL_MOUSEWHEEL = SEL_MOUSEWHEEL
	SIGNAL_CHANGED = SEL_CHANGED
	SIGNAL_VERIFY = SEL_VERIFY
	SIGNAL_DESELECTED = SEL_DESELECTED
	SIGNAL_SELECTED = SEL_SELECTED
	SIGNAL_INSERTED = SEL_INSERTED
	SIGNAL_REPLACED = SEL_REPLACED
	SIGNAL_DELETED = SEL_DELETED
	SIGNAL_OPENED = SEL_OPENED
	SIGNAL_CLOSED = SEL_CLOSED
	SIGNAL_EXPANDED = SEL_EXPANDED
	SIGNAL_COLLAPSED = SEL_COLLAPSED
	SIGNAL_BEGINDRAG = SEL_BEGINDRAG
	SIGNAL_ENDDRAG = SEL_ENDDRAG
	SIGNAL_DRAGGED = SEL_DRAGGED
	SIGNAL_LASSOED = SEL_LASSOED
	SIGNAL_TIMEOUT = SEL_TIMEOUT
	SIGNAL_SIGNAL = SEL_SIGNAL
	SIGNAL_CLIPBOARD_LOST = SEL_CLIPBOARD_LOST
	SIGNAL_CLIPBOARD_GAINED = SEL_CLIPBOARD_GAINED
	SIGNAL_CLIPBOARD_REQUEST = SEL_CLIPBOARD_REQUEST
	SIGNAL_CHORE = SEL_CHORE
	SIGNAL_FOCUS_SELF = SEL_FOCUS_SELF
	SIGNAL_FOCUS_RIGHT = SEL_FOCUS_RIGHT
	SIGNAL_FOCUS_LEFT = SEL_FOCUS_LEFT
	SIGNAL_FOCUS_DOWN = SEL_FOCUS_DOWN
	SIGNAL_FOCUS_UP = SEL_FOCUS_UP
	SIGNAL_FOCUS_NEXT = SEL_FOCUS_NEXT
	SIGNAL_FOCUS_PREV = SEL_FOCUS_PREV
	SIGNAL_DND_ENTER = SEL_DND_ENTER
	SIGNAL_DND_LEAVE = SEL_DND_LEAVE
	SIGNAL_DND_DROP = SEL_DND_DROP
	SIGNAL_DND_MOTION = SEL_DND_MOTION
	SIGNAL_DND_REQUEST = SEL_DND_REQUEST
	#SIGNAL_UNCHECK_OTHER = SEL_UNCHECK_OTHER
	#SIGNAL_UNCHECK_RADIO = SEL_UNCHECK_RADIO
	SIGNAL_IO_READ = SEL_IO_READ
	SIGNAL_IO_WRITE = SEL_IO_WRITE
	SIGNAL_IO_EXCEPT = SEL_IO_EXCEPT
	SIGNAL_PICKED = SEL_PICKED
	SIGNAL_LAST = SEL_LAST

	@nextSignal = SEL_LAST
	def GUI.newSignal
		val = @nextSignal
		@nextSignal += 1
		return val
	end

	class App < FXApp
		Title = '<default title>'
		Vendor = '<default vendor>'
		def initialize(title=Title, vendor=Vendor)
			super(title, vendor)
			ColourScheme.set(self.class::ColourScheme) if ColourScheme
		end

		def quit
			confirm = ConfirmDialog.new(self, 'Quit?', 'Are you sure you want to quit?')
			if confirm.execute
				puts 'Exiting...'
				exit
			end
		end
	end
	class ArrowButton < FXArrowButton
		def initialize(*args)
			super(*args)
			ColourScheme.setColours(self, Button)
			setFrameStyle(Fox::FRAME_RAISED|Fox::FRAME_THICK)
#			setArrowColor(ColourScheme[:foreground][type])
		end
	end
	class Button < FXButton
		def initialize(*args)
			super(*args)
			ColourScheme.setColours(self)
		end
	end
	class CancelButton < Button
		def initialize(parent, label='&Cancel', target=parent)
			super(parent, label, nil, target, DialogBox::ID_CANCEL)
		end
	end
	class CheckButton < FXCheckButton
		def initialize(*args)
			super(*args)
			ColourScheme.setColours(self)
			setBoxColor(ColourScheme[:foreground][self.class])
		end
	end
	class ComboBox < FXComboBox
		def initialize(*args)
			super(*args)
			ColourScheme.setColours(self)
			setComboStyle(Fox::COMBOBOX_INSERT_LAST)
			setFrameStyle(Fox::FRAME_SUNKEN|Fox::FRAME_THICK)
			#|LAYOUT_SIDE_TOP)
		end
	end
	class DialogBox < FXDialogBox
		def initialize(*args)
			super(*args)
			setDecorations(Fox::DECOR_ALL)
			ColourScheme.setColours(self)
		end
		def create
			super
			show(Fox::PLACEMENT_OWNER)
		end
		def execute
			result = super(Fox::PLACEMENT_OWNER)
			return result != 0
		end
	end
	class FileDialog < FXFileDialog
		def initialize(*args)
			super(*args)
			ColourScheme.setColours(self)
		end
	end
	class GroupBox < FXGroupBox
		def initialize(*args)
			super(*args)
			setPad(0)
			ColourScheme.setColours(self)
		end
	end
	class Frame < GroupBox
		def initialize(*args)
			super(*args)
			setGroupBoxStyle(Fox::GROUPBOX_TITLE_LEFT)
			setFrameStyle(Fox::FRAME_GROOVE)
			setLayoutHints(LAYOUT_FILL_BOTH)
			setPad(5)
		end
	end
	class HorizontalFrame < FXHorizontalFrame
		def initialize(*args)
			super(*args)
			ColourScheme.setColours(self)
		end
	end
	class HorizontalSeparator < FXHorizontalSeparator
		def initialize(*args)
			super(*args)
			ColourScheme.setColours(self)
		end
	end
	class Label < FXLabel
		def initialize(*args)
			super(*args)
			ColourScheme.setColours(self)
		end
	end
	class List < FXList
		def initialize(*args)
			super(*args)
			ColourScheme.setColours(self)
		end
	end
	class ListBox < FXListBox
		def initialize(*args)
			super(*args)
			ColourScheme.setColours(self)
		end
	end
	class ListItem < FXListItem
		def initialize(*args)
			super(*args)
			ColourScheme.setColours(self)
		end
	end
	class MainWindow < FXMainWindow
		def initialize(*args)
			super(*args)
			connect(SIGNAL_CLOSE) {
				app.quit
			}
			ColourScheme.setColours(self)
		end
	end
	class Matrix < FXMatrix
		def initialize(*args)
			super(*args)
			ColourScheme.setColours(self)
		end
	end
	class Menubar < FXMenuBar
		def initialize(*args)
			super(*args)
			ColourScheme.setColours(self)
		end
	end
	class MenuCommand < FXMenuCommand
		def initialize(*args)
			super(*args)
			ColourScheme.setColours(self)
		end
	end
	class MenuPane < FXMenuPane
		def initialize(*args)
			super(*args)
			ColourScheme.setColours(self)
		end
	end
	class MenuSeparator < FXMenuSeparator
		def initialize(*args)
			super(*args)
			ColourScheme.setColours(self)
		end
	end
	class MenuTitle < FXMenuTitle
		def initialize(*args)
			super(*args)
			ColourScheme.setColours(self)
		end
	end
	class OkayButton < Button
		def initialize(parent, label='&Okay', target=parent)
			super(parent, label, nil, target, DialogBox::ID_ACCEPT)
		end
	end
	class RadioButton < FXRadioButton
		def initialize(*args)
			super(*args)
			ColourScheme.setColours(self)
			setRadioColor(ColourScheme[:foreground][self.class])
		end
	end
	class ScrollWindow < FXScrollWindow
		def initialize(*args)
			super(*args)
			ColourScheme.setColours(self)
			ColourScheme.setColours(horizontalScrollbar)
			ColourScheme.setColours(verticalScrollbar)
		end
	end
	class StatusBar < FXStatusBar
		def initialize(*args)
			super(*args)
			ColourScheme.setColours(self)
			ColourScheme.setColours(getStatusLine)
			ColourScheme.setColours(getDragCorner)
		end
	end
	class Switcher < FXSwitcher
		def initialize(*args)
			super(*args)
			ColourScheme.setColours(self)
		end
	end
	class Text < FXText
		def initialize(*args)
			super(*args)
			ColourScheme.setColours(self)
		end
	end
	class TextField < FXTextField
		def initialize(*args)
			super(*args)
			ColourScheme.setColours(self)
		end
	end
	class VerticalFrame < FXVerticalFrame
		def initialize(*args)
			super(*args)
			ColourScheme.setColours(self)
		end
	end


	# Custom widgets.

	class HorizontalButtonFrame < HorizontalFrame
		def initialize(*args)
			super(*args)
			setHSpacing(5)
			setLayoutHints(Fox::LAYOUT_RIGHT|Fox::LAYOUT_BOTTOM)
			ColourScheme.setColours(self)
		end
	end

	class ConfirmDialog < DialogBox
		def initialize(parent, title='Confirm', text='Please confirm')
			super(parent, title)
			l = Label.new(self, text)
			s = HorizontalSeparator.new(self)
			f = HorizontalButtonFrame.new(self)
			f.setLayoutHints(LAYOUT_RIGHT)
			ok = OkayButton.new(f, '&Okay', self)
			ok.setDefault
			ok.setFocus
			cancel = CancelButton.new(f, '&Cancel', self)
		end
	end

	class ErrorDialog < DialogBox
		def initialize(parent, text=nil)
			super(parent, 'Error')
			setWidth(300)
			setHeight(200)
			case text
			when Array
				text = text.join("\n")
			end
			puts text
			v = VerticalFrame.new(self)
			v.setLayoutHints(LAYOUT_FILL_BOTH)
			if text
				t = Text.new(v)
				t.setTextStyle(TEXT_WORDWRAP|TEXT_READONLY)
				t.setLayoutHints(LAYOUT_FILL_BOTH)
				t.setText(text)
			end
			HorizontalSeparator.new(v)
			f = HorizontalButtonFrame.new(v)
			f.setLayoutHints(LAYOUT_RIGHT)
			ok = Button.new(f, '&Okay', nil, self, ID_ACCEPT)
			ok.setDefault
			ok.setFocus
		end
	end

	class ButtonTray < FXComposite
		attr :frame
		def initialize(parent, backColour=0x888888)
			super(parent)
			@backColour = backColour

			@scrollWindow = ScrollWindow.new(parent)
			@scrollWindow.setLayoutHints(LAYOUT_FILL_BOTH)

			@frame = VerticalFrame.new(@scrollWindow)
			@frame.setFrameStyle(FRAME_SUNKEN | FRAME_THICK)
			@frame.setBackColor(backColour)
			@frame.setLayoutHints(LAYOUT_FILL_BOTH)
		end
		def method_missing(m, *args)
			eval("@scrollWindow.#{m}(*args)")
		end
	end

	class TrayButton < Button
		def initialize(parent, caption, icon, desc='')
			if parent.is_a? ButtonTray
				parent = parent.frame
			end
			f = HorizontalFrame.new(parent)
			f.setLayoutHints(LAYOUT_FILL_X)
			f.setBackColor(parent.getBackColor)
			b = Button.new(f, '', icon)
			b.setPad(-2)
			b.setBackColor(parent.getBackColor/2)
			b.setTextColor(0x000000)
			b.command { |*args|
				@callback.call(*args) if @callback
			}

			l = Label.new(f, caption)
			l.setLayoutHints(LAYOUT_RIGHT|LAYOUT_FILL_X)
			l.setBackColor(parent.getBackColor)
			l.setJustify(JUSTIFY_RIGHT)

			HorizontalSeparator.new(parent)
		end
		def command(&block)
			@callback = block
		end
	end

	# Colour scheme support is a bit of work for FOX...
	module Colours
		Black = 0x000000
		Blue = 0xFF0000
		Green = 0x00FF00
		Red = 0x0000FF
		White = 0xFFFFFF
		Grey = 0x808080
		LightGrey = 0xbdbebd
		def Colours.rgb2bgr(bgr)
			b = (bgr >> 16) & 0xFF
			g = (bgr >> 8) & 0xFF
			r = bgr & 0xFF
			return ((r << 16) | (g << 8) | b)
		end
	end
	class ColourScheme
		DefaultColourScheme = {}
		DefaultColourScheme[:background] = {}
		DefaultColourScheme[:background].default = Colours::LightGrey
		DefaultColourScheme[:foreground] = {}
		DefaultColourScheme[:foreground].default = Colours::Red
		DefaultColourScheme[:text] = {}
		DefaultColourScheme[:text].default = Colours::Black
		DefaultColourScheme[:highlight] = {}
		DefaultColourScheme[:highlight].default = Colours::White
		DefaultColourScheme[:shadow] = {}
		DefaultColourScheme[:shadow].default = Colours::Black
		DefaultColourScheme[:base] = {}
		DefaultColourScheme[:base].default = Colours::White
		@colourScheme = DefaultColourScheme
		def ColourScheme.[](value)
			return @colourScheme[value]
		end
		def ColourScheme.set(value=DefaultColourScheme)
			# Convert rgb -> bgr (used by FOX GUI)
			@colourScheme = value
			@colourScheme.each { |colour, klassHash|
				klassHash.default = Colours::rgb2bgr(klassHash.default)
				klassHash.each { |klass, val|
					@colourScheme[colour][klass] = Colours::rgb2bgr(val)
				}
			}
		end
		def ColourScheme.setColour(colour, klass, val=DefaultColourScheme[colour][klass])
			@colourScheme[colour][klass] = Colours::rgb2bgr(val)
		end
		def ColourScheme.setColours(widget, t=widget.class)
			widget.setForeColor(@colourScheme[:foreground][t]) if widget.respond_to?(:setForeColor)
			widget.setBackColor(@colourScheme[:background][t]) if widget.respond_to?(:setBackColor)
			widget.setTextColor(@colourScheme[:text][t]) if widget.respond_to?(:setTextColor)
			widget.setHiliteColor(@colourScheme[:highlight][t]) if widget.respond_to?(:setHiliteColor)
			widget.setShadowColor(@colourScheme[:shadow][t]) if widget.respond_to?(:setShadowColor)
			widget.setBaseColor(@colourScheme[:base][t]) if widget.respond_to?(:setBaseColor)
			widget.setSelBackColor(@colourScheme[:background_selected][t]) if widget.respond_to?(:setSelBackColor)
			widget.setSelTextColor(@colourScheme[:text_selected][t]) if widget.respond_to?(:setSelTextColor)
		end
	end
end

