$__warn_constants = {}
$__warn_constants_file_regexp = /blake-shared/

module WarnOnUse
  def self.included(target)
    if $__warn_constants_file_regexp.match?(caller.last)
      sym = target.name.to_sym
      $__warn_constants[sym] = { def: target, file: caller.last.sub(/:in.*$/, '') }
      Object.send(:remove_const, sym)
    end
  end
end

def Object.const_added(name)
  p name
  super name
end

def Object.const_missing(name)
  if marked = $__warn_constants[name]
    call_location = caller.last.sub(/:in.*$/, '')
    warn "WARNING: Using #{marked[:def]} defined in #{marked[:file]} from #{call_location}"
    marked[:def]
  else
    super(name)
  end
end

class Foo
  include WarnOnUse

  attr_accessor :x
end

f = Foo.new
f.x = 2
p f

