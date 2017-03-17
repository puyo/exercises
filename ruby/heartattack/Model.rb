class Model
	Variables = []

	def Model.attr(symbol)
		symbol = symbol.to_s
		eval("@#{symbol} = nil") # Make symbol an instance variable.
		Variables << symbol
	end

	def addObserver(observer)
		unless observer.respond_to?('update')
			raise "Attempt to add non-observer as observer of model: " . observer.type
		end
		ensureObserversExists
		@observers.push observer
		observer.update(self)
	end

	def removeObserver(observer)
		@observers.delete observer
	end

	def notifyObservers
		eachObserver { |o|
			o.update(self)
		}
	end

	def eachObserver
		ensureObserversExists
		@observers.each { |o|
			yield o
		}
	end

	# Redefine method_missing such that attempts to set variables
	# result in the variable being set, and observers being notified.
	def method_missing(method, *args)
		variable = method.to_s

		if variable[-1].chr == '='
			variable.chop! # Remove the '='
			setter = true
		end

		if Variables.include?(variable)
			value = eval('@' + variable)
			if setter
				eval("@#{variable} = #{args[0].inspect}")
				notifyObservers
			else
				return value
			end
		else
			super # Raise undefined method exception.
		end
	end

	private
	def ensureObserversExists
		if @observers == nil
			@observers = []
		end
	end
end
