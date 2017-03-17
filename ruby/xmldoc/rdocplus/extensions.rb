
class Directory
  def self.relative(from, to)
    from = File.expand_path(from).split(File::SEPARATOR)
    to = File.expand_path(to).split(File::SEPARATOR)
    maxsize = [from.size, to.size].max
    from.fill(nil, from.size, maxsize-from.size)
    to.fill(nil, to.size, maxsize-to.size)
    result = []
    for i in 0...maxsize
      if from.first == to.first
        from.shift
        to.shift
      end
    end
    return to.map{|t| t || '..' }.join(File::SEPARATOR)
  end
end

def print_progress(char='.')
  STDOUT.print char
  STDOUT.flush
end

class Array
  def each_with_even_odd
    each_with_index do |elem, index|
      evenodd = ((index % 2) == 0) ? :even : :odd
      yield elem, evenodd
    end
  end

  def join_path
    File.join(self)
  end
end

if $0 == __FILE__
  p Directory.relative('/home/puyo/projects', '/home') # => "../.."
  p Directory.relative('/home', '~puyo/projects')      # => "puyo/projects"
  p Directory.relative('/home', '/home')               # => ""
  p Directory.relative('/home', '/home/a/blah.txt')
end
