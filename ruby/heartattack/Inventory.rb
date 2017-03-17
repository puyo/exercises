require_relative 'Item'

class InventoryException < Exception
end

class Inventory
	def initialize(model)
		@items = []
		@model = model
	end

	def add(item)
		unless item.is_a?(Item)
			raise InventoryException, "Cannot add a #{item.type} to an Inventory. Can only add an Item."
		end
		@items.each { |i|
			if i.type == item.type
				i.number += item.number
				@model.notifyObservers
				return
			end
		}
		@items << item
		@model.notifyObservers
		return
	end
	def remove(type, quantity=1)
		unless type.is_a?(Class)
			type = type.type
		end
		found = false
		@items.each { |i|
			if i.type == type
				found = true
				if i.number == quantity
					@items.delete(i)
				elsif i.number < quantity
					raise InventoryException, "Cannot remove #{quantity} #{type} items, only have #{i.number}."
				else
					i.number -= quantity
				end
				@model.notifyObservers
				return
			end
		}
		unless found
			raise InventoryException, "Did not find any #{type} objects."
		end
	end
	def sort!
		@items.sort!
		@model.notifyObservers
	end
	def clear
		@items.clear
		@model.notifyObservers
	end
	def empty?
		return @items.empty?
	end
	def has?(item)
		return @items.include?(item)
	end

	def to_s
		return '[' + @items.join(', ') + ']'
	end
	def inspect
		return @items.inspect
	end
end

require_relative 'Model'

class M < Model
	def notifyObservers
	end
end

# Some example items.

class Flower < Item
	def *(num)
		return type.new(num)
	end
end

class Tulip < Flower
end

class Bread < Item
	def plural; 'pieces of bread' end
end
