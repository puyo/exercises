require 'GUI'

MONTH_NAMES = '0 January February March April May June July August September October November December'.split
MONTH_DAYS = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

class Portrait < GUI::Label
	include GUI

	MaxWidth = 200
	MaxHeight = 200

	def initialize(parent, filename, maxWidth=MaxWidth, maxHeight=MaxHeight)
		super(parent, '')
		icon = makeIcon(filename, 'data/portraits')
		
		maxAspectRatio = MaxWidth/MaxHeight.to_f
		portraitAspectRatio = icon.width/icon.height.to_f

		if maxAspectRatio < portraitAspectRatio
			width = maxWidth
			height = ((icon.height * maxWidth).to_f/icon.width.to_f).to_i
		else
			width = ((icon.width * maxHeight).to_f/icon.height.to_f).to_i
			height = maxHeight
		end
		icon.scale(width, height)

		setLayoutHints(LAYOUT_FIX_BOTH)
		setWidth(maxWidth)
		setHeight(maxHeight)
		setIcon(icon)
	end
end

class PictureSet < Array
	def load()
	end
end

class PictureFrame < GUI::Frame
	include GUI

	def initialize(parent)
		super(parent, "Picture")

		main = VerticalFrame.new(self)
		main.setLayoutHints(LAYOUT_FILL_BOTH)

		picture = Portrait.new(main, 'abmascot_hres')

		f = HorizontalButtonFrame.new(main)
		f.setLayoutHints(LAYOUT_FILL_BOTH)

		left = ArrowButton.new(f, nil, 0, LAYOUT_FILL_X|FRAME_RAISED|FRAME_THICK|ARROW_LEFT)
		left.setArrowSize(15)

		right = ArrowButton.new(f, nil, 0, LAYOUT_FILL_X|FRAME_RAISED|ARROW_RIGHT)
		right.setArrowSize(15)

		f = HorizontalButtonFrame.new(main)
		f.setLayoutHints(LAYOUT_FILL_BOTH)
		import = Button.new(f, '&Import')
		import.setLayoutHints(LAYOUT_RIGHT)
	end
end

class DetailsMatrix < GUI::Matrix
	include GUI
	def initialize(parent)
		super(parent, 2, MATRIX_BY_COLUMNS)
		nameLabel = Label.new(self, "&Name:")
		nameField = TextField.new(self, 32)
		genderLabel = Label.new(self, "&Gender:")
		genderGroup = GroupBox.new(self, '')
		maleButton = RadioButton.new(genderGroup, 'male')
		femaleButton = RadioButton.new(genderGroup, 'female')
		birthdayLabel = Label.new(self, '&Birthday:')
		birthdayFrame = VerticalFrame.new(self)
		birthdayFrame.setPad(0)
		birthdayGroup = GroupBox.new(birthdayFrame, '')
		randomButton = RadioButton.new(birthdayGroup, 'random')
		customButton = RadioButton.new(birthdayGroup, 'custom')
		dateFrame = HorizontalFrame.new(birthdayFrame)
		dateFrame.setPad(0)

		dayDropBox = ComboBox.new(dateFrame, 6, 12)
		dayDropBox.appendItem('<Day>')
		for i in 1..31
			dayDropBox.appendItem(i.to_s)
		end
		dayDropBox.disable

		monthDropBox = ComboBox.new(dateFrame, 10, 12)
		monthDropBox.appendItem('<Month>')
		require 'date'
		for i in 1...12
			monthDropBox.appendItem(Date::MONTHNAMES[i].to_s)
		end
		monthDropBox.disable

		customButton.connect {
			if customButton.check
				dayDropBox.enable
				monthDropBox.enable
			else
				dayDropBox.disable
				monthDropBox.disable
			end
		}

		monthDropBox.connect {
			day = dayDropBox.currentItem.to_i
			month = monthDropBox.currentItem.to_i

			dayDropBox.clearItems
			daysInMonth = MONTH_DAYS[month]
			dayDropBox.appendItem('<Day>')
			for i in 1..daysInMonth
				dayDropBox.appendItem(i.to_s)
			end

			if day > daysInMonth
				day = daysInMonth
			end
			dayDropBox.currentItem = day
		}
	end	
end

class PersonCreationWindow < GUI::DialogBox
	include GUI

	Title = 'Person Creation Window'
	
	def initialize(parent)
		super(parent, Title)

		@mainFrame = VerticalFrame.new(self)
		@mainFrame.setPad(0)
		@mainFrame.setLayoutHints(LAYOUT_FILL_BOTH)

		@topFrame = HorizontalFrame.new(@mainFrame)
		@topFrame.setPad(0)
		@topFrame.setLayoutHints(LAYOUT_FILL_BOTH)

		@pictureFrame = PictureFrame.new(@topFrame)
		@pictureFrame.setLayoutHints(LAYOUT_FILL_Y)

		@detailsFrame = Frame.new(@topFrame, 'Details')
		@detailsFrame.setLayoutHints(LAYOUT_FILL_BOTH)

		@detailsMatrix = DetailsMatrix.new(@detailsFrame)

		buttonsFrame = HorizontalButtonFrame.new(@mainFrame)
		save = Button.new(buttonsFrame, '&Save')
		cancel = CancelButton.new(buttonsFrame, '&Cancel', self)
	end
end

class StudentCreationWindow < PersonCreationWindow
	include GUI
	Title = 'Student Creation Window'
end

class YouCreationWindow < StudentCreationWindow
	include GUI
	Title = 'Character Creation Window'
end

class FriendCreationWindow < StudentCreationWindow
	include GUI
	Title = 'Friend Creation Window'
end
