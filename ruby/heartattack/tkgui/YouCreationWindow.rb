require 'You'
require 'GUI'

class YouCreationWindow < TkFrame

	Adjectives = {}
	Adjectives['metabolism'] = {}
	Adjectives['metabolism'][1] = 'Morbidly Obese'
	Adjectives['metabolism'][2] = 'Fat'
	Adjectives['metabolism'][3] = 'Plump'
	Adjectives['metabolism'][4] = 'Chubby'
	Adjectives['metabolism'][5] = 'Average'
	Adjectives['metabolism'][6] = 'Healthy'
	Adjectives['metabolism'][7] = 'Taut'
	Adjectives['metabolism'][8] = 'Fit'
	Adjectives['metabolism'][9] = 'Athletic'
	Adjectives['metabolism'][10] = 'Buff'
	Adjectives['beauty'] = {}
	Adjectives['beauty'][1] = 'Hideous'
	Adjectives['beauty'][2] = 'Ugly'
	Adjectives['beauty'][3] = 'Unfortunate'
	Adjectives['beauty'][4] = 'Homely'
	Adjectives['beauty'][5] = 'Plain'
	Adjectives['beauty'][6] = 'Pleasant Looking'
	Adjectives['beauty'][7] = 'Cute'
	Adjectives['beauty'][8] = 'Hot'
	Adjectives['beauty'][9] = 'Dashing'
	Adjectives['beauty'][10] = 'Babelicious'
	Adjectives['intelligence'] = {}
	Adjectives['intelligence'][1] = 'Imbecilic'
	Adjectives['intelligence'][2] = 'Stupid'
	Adjectives['intelligence'][3] = 'Dumb'
	Adjectives['intelligence'][4] = 'Slow'
	Adjectives['intelligence'][5] = 'Mediocre'
	Adjectives['intelligence'][6] = 'Bright'
	Adjectives['intelligence'][7] = 'Quick'
	Adjectives['intelligence'][8] = 'Smart'
	Adjectives['intelligence'][9] = 'Brilliant'
	Adjectives['intelligence'][10] = 'Genius'

	Difficulty = [nil] # Make difficulties 1-based.
	Difficulty << 'Trivial'
	Difficulty << 'Tame'
	Difficulty << 'Easy'
	Difficulty << 'Elementary'
	Difficulty << 'Simple'
	Difficulty << 'Straightforward'
	Difficulty << 'Basic'
	Difficulty << 'Manageable'
	Difficulty << 'Doable'
	Difficulty << 'Feasible'
	Difficulty << 'Average'
	Difficulty << 'Mediocre'
	Difficulty << 'Moderate'
	Difficulty << 'Ordinary'
	Difficulty << 'Normal'
	Difficulty << 'Reasonable'
	Difficulty << 'Challenging'
	Difficulty << 'Tough'
	Difficulty << 'Troublesome'
	Difficulty << 'Hard'
	Difficulty << 'Difficult'
	Difficulty << 'Improbable'
	Difficulty << 'Formidable'
	Difficulty << 'Unreasonable'
	Difficulty << 'Inhumane'
	Difficulty << 'Horrible'
	Difficulty << 'Foolish'
	Difficulty << 'Absurd'

	def initialize(parent)
		super(parent)

		relief 'raised'
		borderwidth 1
		fill 'both'
		anchor 'nw'
		expand true

		heading = TkLabel.new(self)
		heading.set 'Character Creation'
		heading.side 'top'
		heading.anchor 'nw'
		heading.pack

		@difficulty = TkVariable.new
		@difficulty.value = Initial::Difficulty

		@grid = TkFrame.new(self)
		row = 1

		# Name
		label = TkLabel.new(@grid)
		label.set 'Name: '
		label.grid('row' => row, 'column' => 1, 'sticky' => 'w')
		@name = TkEntry.new(@grid)
		@name.grid('row' => row, 'column' => 2, 'sticky' => 'w')
		row += 1

		# Gender
		label = TkLabel.new(@grid)
		label.set 'Gender: '
		label.grid('row' => row, 'column' => 1, 'sticky' => 'w')
		genderFrame = TkFrame.new(@grid)
		@gender = TkVariable.new
		@male = TkRadioButton.new(genderFrame)
		@male.text 'Male'
		@male.value Person::Genders[0]
		@male.variable @gender
		@male.side 'left'
		@male.command {
			setGender(@gender.value)
		}
		@male.pack
		@female = TkRadioButton.new(genderFrame)
		@female.text 'Female'
		@female.value Person::Genders[1]
		@female.variable @gender
		@female.side 'right'
		@female.command {
			setGender(@gender.value)
		}
		@female.pack
		genderFrame.grid('row' => row, 'column' => 2, 'sticky' => 'w')
		@grid.pack

		# Attributes
		@scalesGrid = TkFrame.new(self)
		@scalesGrid.fill 'both'
		@scalesGrid.expand true
		@scalesGrid.anchor 'nw'
		@scalesGrid.side 'left'
		@scalesGrid.pack

		@scales = {}
		@adjectives = {}
		row = 1
		You::Attributes.each { |a|
			makeRow(row, a)
			row += 1
		}

		# Difficulty rating
		@difficultyRating = TkLabel.new(self)
		@difficultyRating.width 50
		@difficultyRating.pack

		# Okay button
		okay = TkButton.new(self)
		okay.text 'Okay'
		okay.borderwidth 1
		okay.side 'bottom'
		okay.command {
			if okayValid then
				nextStep
			end
		}
		okay.pack

		@you = You.new
		@you.addObserver(self)
	end

	def okayValid
		# Check if name has been entered.
		name = @name.value.strip
		nameOkay = (Person::ValidName =~ name)
		if nameOkay == nil then 
			p 'Name not vaild'
			return false
		end

		# Check if a gender has been chosen
		if @gender.value == '' then
			p 'No gender chosen'
			return false 
		else 
			return true
		end
	end

	def nextStep
		p 'move onto next step'
		saveValues
		@you.removeObserver(self)
		Game.getType
	end
	
	def saveValues
		@you.name = @name.value
		@you.gender = @gender.value
		@you.metabolism = @scales['metabolism'].value
		@you.beauty = @scales['beauty'].value
		@you.intelligence = @scales['intelligence'].value
	end

	def update(model)
		totalSpent = 0
		You::Attributes.each { |a|
			value = eval('model.' + a)
			@scales[a].set value
			@adjectives[a].text Adjectives[a][value]
			totalSpent += value
		}
		@difficulty.value = Initial::Difficulty - totalSpent
		@difficultyRating.text 'Difficulty Rating: ' + Difficulty[@difficulty.value.to_i] + ' (' + @difficulty.value.to_s + ')'
	end

	# Create a row to hold all the widgets used to set a single
	# attribute and pack it into the grid.
	def makeRow(row, attribute)
		col = 0

		# Attribute name.
		attributeLabel = TkLabel.new(@scalesGrid)
		attributeLabel.text attribute.capitalize
		attributeLabel.grid('row' => row, 'column' => col, 'sticky' => 'w')
		col += 1

		# =
		equals = TkLabel.new(@scalesGrid)
		equals.text ' = '
		equals.grid('row' => row, 'column' => col)
		col += 1

		# Scale, to allow user to spend attribute points here.
		@scales[attribute] = TkScale.new(@scalesGrid)
		@scales[attribute].from 1
		@scales[attribute].to 10
		@scales[attribute].orient 'horizontal'
		@scales[attribute].command proc { |v|
			setAttribute(attribute, v)
		}
		@scales[attribute].grid('row' => row, 'column' => col)
		col += 1

		# Adjective
		@adjectives[attribute] = TkLabel.new(@scalesGrid)
		@adjectives[attribute].width 20
		@adjectives[attribute].grid('row' => row, 'column' => col)
		col += 1
	end

	def setAttribute(name, value)
		eval("@you.#{name} = #{value}")
	end
	def setGender(value)
		eval("@you.gender = '#{value}'")
	end
	def setName(value)
		eval("@you.name = '#{value}'")
	end
end
