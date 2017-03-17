#! /usr/bin/env ruby

require_relative './GUI'

class CharGen

	NAME = 'Character Generator Template'
	ABOUT = 'A template character generator in Ruby/Tk by Greg McIntyre.'

	def createWindow

		# Create the root window and give it a title.
		$win = TkRoot.new { 
			title CharGen::NAME
		}

		# Add a frame to contain the menus.
		menubar = TkFrame.new {
			relief 'raised'
			borderwidth 2
			pack 'side' => 'top', 
				'fill' => 'x', 
				'expand' => 'true'
		}

		# Add the menus.
		m = menubar.addMenu('File')
		m.addCommand 'label' => 'New...', 
			'command' => proc { menuNew },
			'accelerator' => 'Ctrl+N',
			'tkkey' => 'Control-Key-n'
		m.addCommand 'label' => 'Open...', 
			'command' => proc { menuOpen },
			'accelerator' => 'Ctrl+O',
			'tkkey' => 'Control-Key-o'
		m.addSeparator
		m.addCommand 'label' => 'Exit',
			'underline' => 1,
			'command' => proc { menuExit },
			'accelerator' => 'Ctrl+X',
			'tkkey' => 'Control-Key-x'

		m = menubar.addMenu('Edit')
		m.addCommand 'label' => 'Dunno. Stuff'

		m = menubar.addMenu( 'Help', 0, 'right')
		m.addCommand 'label' => 'About...',
			'command' => proc { menuAbout }
			
		# The main area.
		main = TkFrame.new {
			pack 'padx' => 300,
				'pady' => 200
		}
	end

	def menuNew
		print "New\n"
	end

	def menuOpen
		print "Open\n"
	end

	def menuExit
		d = TkDialog.new 'title' => 'Exit',
			'buttons' => ['Okay', 'Cancel'],
			'message' => 'Exit?'
		if d.value == 0
			exit
		end
	end

	def menuAbout
		TkDialog.new 'title' => 'About',
			'buttons' => ['Okay'],
			'message' => ABOUT
	end
end

class Character
	attr_accessor :name
	def initialize
		@name = '(unnamed)'
	end
end

cg = CharGen.new
cg.createWindow
Tk.mainloop
exit
