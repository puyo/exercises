require 'delegate'

class IntegerModulo
  attr_accessor :value
  attr_accessor :modulo

  def initialize(modulo, initial=0)
    @value = initial
    @modulo = modulo
  end

  def value
    @value % @modulo
  end

  alias to_i value
end

if $PROGRAM_NAME == __FILE__
  x = IntegerModulo.new(13, 1)
  20.times { p x.value; x *= 2 }

  arr = "a b c".split
  y = IntegerModulo.new(arr.size)
  20.times { p arr[y.value]; y = y.succ; }
end
