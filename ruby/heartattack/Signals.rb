# Tie in a more general signal/slot mechanism with FXRuby's
# message/target system.

require 'fox16'

class GlobalTarget < Fox::FXObject

	include Fox
	include Responder

	def initialize
		super
		@blocks = {}
	end

	def connect(id, signal, meth, block)
#		puts "connect(#{id}, #{signal}, #{meth}, #{block})"
		@blocks[signal] = {} if not @blocks[signal]
		@blocks[signal][id] = [] if not @blocks[signal][id]
		if meth != nil
			@blocks[signal][id] << meth.to_proc
		else
			@blocks[signal][id] << block
		end
		FXMAPTYPE(signal, '_handleFXMessage')
	end
	
	def _handleFXMessage(sender, sel, ptr)
		signal = Fox::SELTYPE(sel) 
		id = sender.__id__
#		puts "_handleFXMessage(#{id}, #{signal}, #{ptr})"
		@blocks[signal] = {} if not @blocks[signal]
		@blocks[signal][id] = [] if not @blocks[signal][id]
		@blocks[signal][id].each { |p|
			p.call(id)
		}
	end

	def emit(signal, *args)
#		puts "emit(#{signal})"
		@blocks[signal] = {} if not @blocks[signal]
		@blocks[signal].each { |id, blocks|
			blocks.each { |b|
				b.call(id)
			}
		}
	end
end

$globalTarget = GlobalTarget.new

class Object
	def connect(signal, meth=nil, &block)
		setTarget($globalTarget)
		$globalTarget.connect(self.__id__, signal, meth, block)
	end
	def emit(signal, *args)
		$globalTarget.emit(signal, *args)
	end
end

# Overwrite FOX GUI's version of the connect method with ours.
module Responder2
	def connect(signal=Fox::SEL_COMMAND, meth=nil, &block)
		setTarget($globalTarget)
		$globalTarget.connect(self.__id__, signal, meth, block)
	end
end
