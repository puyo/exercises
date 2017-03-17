require 'tk'
require 'tkscrollbox'

class TkButton
	def set(value)
		text value
	end
end

class TkLabel
	def set(value)
		text value
	end
end

# Add a method to TkWindow for our own nefarious purposes.
class TkWindow
	def side(val) @side = val end
	def anchor(val) @anchor = val end
	def fill(val) @fill = val end
	def expand(val) @expand = val end
	def padx(val) @padx = val end
	def pady(val) @pady = val end
	def pack(override={})
		hash = {}
		hash['side'] = @side
		hash['anchor'] = @anchor
		hash['fill'] = @fill
		hash['expand'] = @expand
		hash['padx'] = @padx
		hash['pady'] = @pady
		hash.update(override)
		hash.reject! { |k, v| v == nil } # Remove nil values.
		super(self, hash)
	end
end

# Add a method to TkFrame for our own nefarious purposes.
class TkFrame
	# Add a new menu with specified name.
	# Returns the menu, so things may be added to it.
	def addMenu(name, ul=0, side='left')
		mb = TkMenubutton.new(self)
		mb.text name
		mb.underline ul
		mb.side side
		mb.borderwidth 0
		mb.menu TkMenu.new(mb, 'tearoff' => false)
		mb.pack
		return mb
	end
end

# Add a method to TkMenubutton for our own nefarious purposes.
class TkMenubutton
	# Add a command.
	# underline is the character in label to be underlined (0 = first character).
	# callback is the callback method which will be called when this menu item is selected.
	# shortcut is the shortcut key which will be displayed next to the menu item.
	# Also adds the shortcut key defined by 'tkkey'.
	def addCommand(keys)
		# Remove tkkey from keys -- it is not a Tk parameter.
		tkkey = keys['tkkey']
		keys.delete('tkkey')

		# Ensure default underline.
		if not keys['underline']
			keys['underline'] = 0
		end

		# Add the command to the menu.
		menu.add('command', keys)

		# Bind tkkey to this command.
		if tkkey and keys['command']
			Tk.bindKey(tkkey, keys['command'])
		end
	end

	# Add a separator.
	def addSeparator
		menu.add('separator')
	end
end

module Tk
	# Globally bind a key to a callback method (Proc).
	module_function
	def bindKey(key, callback)
		Tk.bind 'all', key do
			callback.call
		end
	end	
end

class TkScrollableTextBox < TkText
	include TkComposite
	def initialize_composite(keys=nil)
		@text = TkText.new(@frame)
		@scroll = TkScrollbar.new(@frame)
		@path = @text.path

		@text.configure 'yscrollcommand', @scroll.path + ' set'
		@scroll.configure 'command', @text.path + ' yview'
		@scroll.side 'right'
		@scroll.fill 'y'

		@text.wrap 'word'
		@text.width 0
		@text.height 10
		@text.state 'disabled'
		@text.side 'left'
		@text.fill 'both'
		@text.expand true

		@text.pack
		@scroll.pack

		delegate('DEFAULT', @text)
		delegate('borderwidth', @frame)
		delegate('relief', @frame)

		configure keys if keys
	end

	def scrollTo(val)
		@text.yview('moveto', val)
	end
end


def loadPicture(dir, filenameBase)
	pictureFileRE = File.join(dir, filenameBase) + '.gif'
	Dir.glob(pictureFileRE).each { |f|
		file = File.expand_path(f)
		extension = file.split('.').pop
		if file and extension == 'gif'
			picture = TkPhotoImage.new
			picture.read(file)
			return picture
		end
	}
	return nil
end

module G
	class Button < TkButton
	end
	class Label < TkLabel
	end
	class ScrollBox < TkScrollbox
		def initialize(parent, width, height)
			super(parent, 'height' => height, 'width' => width)
		end
	end
	class Window < TkWindow
		def initialize(parent, width, height)
			super(parent, 'height' => height, 'width' => width)
		end
	end
end
