
def setTkPalette(*args)
	args = args[0].to_a.flatten if args.kind_of? Array
	args = args.to_a.flatten if args.kind_of? Hash
	TkPalette.tk_call 'tk_setPalette', *args
end


module ColourScheme
	BG = '#404040'
	FG = '#D0D0D0'
	ActiveBG = '#C02040'
	ActiveFG = 'white'
	DisabledFG = 'gray'
	HighlightBG = BG
	Highlight = 'white'
	InsertBG = 'magenta'
	SelectBG = ActiveBG
	SelectFG = ActiveFG
	Trough = BG

	def ColourScheme.default
		colours = {
			'background' => BG,
			'foreground' => FG,
			'activeBackground' => ActiveBG,
			'activeForeground' => ActiveFG,
			'disabledForeground' => DisabledFG,
			'highlightBackground' => BG,
			'highlightColor' => Highlight,
			'insertBackground' => InsertBG,
			'selectBackground' => SelectBG,
			'selectForeground' => SelectFG,
			'troughColor' => Trough,
		}
		return colours
	end

	@colourScheme = ColourScheme.default

	def ColourScheme.get
		return @colourScheme
	end

	def ColourScheme.set(colourScheme)
		unless colourScheme
			set(default)
			return
		end
		@colourScheme = colourScheme
		setTkPalette(@colourScheme)
	end
end

ColourScheme.set(ColourScheme.default)
