require 'interface'

# ---------

puts "Defining Fooable..."

class Fooable < Interface
	Methods = %w[foo1 foo2]
end

# ---------

puts "Defining Barable..."

class Barable < Interface
	Methods = %w[bar1 bar2]
end

# ---------

puts "Defining Foo..."

class Foo
	def foo1; end
	def foo2; end
	def bar1; end
	def bar2; end

	promise Fooable, Barable
end

puts "--"
puts "Defining Bar..."

class Test
	def f(foo, foo2)
		assert_interfaces([foo, Fooable, Barable], [foo2, Fooable, Barable]) # pass
	end
end

puts "--"
puts "Runtime type checking..."

begin
	puts
	foo = Foo.new
	foo2 = 5
	t = Test.new
	t.f(foo, foo2)
rescue TypeError => e
	puts e.message
end

puts "--"
puts "Breaking interface promise..."

begin
	class Foo
		remove_method :bar1
		remove_method :foo1
	end
rescue TypeError => e
	puts e.message
end

begin
	puts
	foo = Foo.new
	foo2 = 5
	t = Test.new
	t.f(foo, foo2)
rescue TypeError => e
	puts e.message
end

puts "--"
puts "Remaking interface promise (manually)..."

class Foo
	def foo1; end
	def bar1; end

	promise Fooable, Barable
end

begin
	puts
	foo = Foo.new
	foo2 = 5
	t = Test.new
	t.f(foo, foo2)
rescue TypeError => e
	puts e.message
end

puts "--"
puts "Trying to break singleton class..."

foo = Foo.new
class << foo
	undef foo1
	check_promises
end
