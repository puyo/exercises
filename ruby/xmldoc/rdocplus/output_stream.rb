
class OutputStream
  def initialize(parameters=nil)
    @parameters = parameters
    @output = ''
  end

  #-----------------------------------------------------------------
  # Queries
  #-------------------------------------------------------------- ++

  attr_reader :parameters
  
  def to_s
    @output
  end
  
  #-----------------------------------------------------------------
  # Commands
  #-------------------------------------------------------------- ++

  def <<(value)
    @output << value
  end
  alias :append :<<

  def write(path)
    File.open(path, 'w') do |f|
      f.print @output
    end
  end
end

