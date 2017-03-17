require 'GUI'

class GameTypeWindow < TkFrame

	Types = 'small normal large custom'.split

	def initialize(parent)
		super(parent)

#		Tk.root.geometry "300x300"

		relief 'raised'
		borderwidth 1
		fill 'both'
		anchor 'nw'
		expand true

		heading = TkLabel.new(self)
		heading.set 'Game Type'
		heading.side 'top'
		heading.anchor 'nw'
		heading.pack

		@type = 'normal'
		f = TkFrame.new(self)
		Types.each { |t|
			r = TkRadioButton.new(f)
			r.text t.capitalize
			r.value t
			r.side 'top'
			r.anchor 'nw'
			r.command {
				setType(t)
			}
			if t == @type
				r.invoke
			end
			r.pack
		}
		f.pack

		# Okay button
		okay = TkButton.new(self)
		okay.text 'Okay'
		okay.borderwidth 1
		okay.side 'bottom'
		okay.command {
			nextStep
		}
		okay.pack
	end
	
	def setType(type)
		@type = type
	end

	def nextStep
		p 'next step'
		p "type = #{@type}"
	end
end
