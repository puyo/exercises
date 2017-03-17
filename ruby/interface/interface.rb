class Interface
	def self.inspect
		"#{super}(#{methods.join(', ')})"
	end

	def self.implemented_by?(object)
		if object.respond_to?(:interfaces)
			object.interfaces.include?(self) # inexpensive check
		else
			(self::Methods - object.methods).empty? # expensive check
		end
	end
end


class Module
	def interfaces
		if defined? @interfaces
			@interfaces
		elsif respond_to?(:superclass) and not superclass.nil?
			superclass.interfaces
		else
			[]
		end
	end

	def check_promises
		puts "  #{self}#assert_promises"

		ensure_interfaces
		implemented = instance_methods(false)

		puts "  #{self}: Implemented methods: #{implemented.join(', ')}"
		puts "  #{self}: Promised interfaces: #{interfaces.join(', ')}"

		problems = []
		interfaces.each do |iface|
			unimplemented = iface::Methods - implemented
			if !unimplemented.empty?
				problems.push [iface, unimplemented]
			end
		end
		unless problems.empty?
			problems.each{|i,u| @interfaces.delete i }
			msg = problems.map{|i,u| "`#{self}' breaks interface `#{i}' as it lacks #{u.map{|m| "`#{m}'"}.join(', ')}" }.join(', ')
			raise TypeError, msg
		end
	end
end

class Object
	alias old_initialize initialize
	def initialize
		old_initialize
		@interfaces = self.class.interfaces
	end

	class << self
		alias old_undef_method undef_method
		def undef_method(*args)
			old_undef_method(*args)
			puts "  #{self}: Removing interfaces"
			@interfaces = []
		end

		alias old_remove_method remove_method
		def remove_method(*args)
			old_remove_method(*args)
			@interfaces = []
		end
	end

	# A run-time 'type check'
	def assert_interfaces(*obj_ifaces)
		puts "  #{self}#assert_interfaces"
		errors = []
		obj_ifaces.each do |obj,*ifaces|
			broken = ifaces.find_all{|iface| !obj.implements?(iface) }
			unless broken.empty?
				errors.push [obj, broken]
			end
		end
		unless errors.empty?
			e = errors.map{|o,i| "#{o.inspect} does not implement interface(s) #{i.join(', ')}" }.join(', ')
			raise TypeError, e
		end
	end

	def implements?(interface)
		interface.implemented_by?(self)
	end

	def promise(*interfaces)
		puts "  #{self}#implements(#{interfaces.join(', ')})"
		ensure_interfaces
		@interfaces.push(*interfaces).uniq!
		check_promises
	end

	def ensure_interfaces
		unless defined? @interfaces
			@interfaces = []
		end
	end
end
