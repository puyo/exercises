require 'tk'

# Add a method to TkFrame for our own nefarious purposes.
class TkFrame
	# Add a new menu with specified name.
	# Returns the menu, so things may be added to it.
	def addMenu(name, ul=0, side='left')
		TkMenubutton.new(self) { |mb|
			text name
			underline ul
			pack 'side' => side,
				'padx' => '1m'
			menu TkMenu.new(mb)
			return mb
		}
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

