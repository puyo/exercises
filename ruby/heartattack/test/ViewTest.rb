require 'Observer'
require 'Person'
require 'GUI'

class View < TkFrame
	def initialize(parent, model)
		super(parent)

		@model = model

		###
		border 1
		relief 'raised'
		expand true
		fill 'both'
		
		@widgets = {}

		model.instance_variables.each { |var|
			l = TkLabel.new(self)
			l.set var + ' = '
			l.pack
			widget = TkButton.new(self)
			widget.command proc { clicked(var) }
			widget.pack
			@widgets[var] = widget
		}
		model.addObserver(self)
	end
	def update(model)
		@widgets.each { |variable, widget|
			value = eval('model.' + variable)
			widget.set value
		}
	end
	def clicked(var)
		if var == 'sex'
			eval '@model.' + var + ' += 1'
		end
	end
end

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
		title 'View Test'
		clear
	end

	def clear
		@contents.unpack if @contents
		@contents = TkFrame.new(self)
		@contents.fill 'both'
		@contents.expand true
		@contents.pack
	end
end

r = RootWindow.new

person = Person.new

person.sex = 1

Tk.root.clear

centre = TkFrame.new(Tk.root.contents)
centre.fill 'both'
centre.expand true
		
view = View.new(centre, person)

view.pack
centre.pack

Tk.mainloop
