require 'rdocplus/html_output_stream'

class CSSOutputStream < OutputStream
  #-----------------------------------------------------------------
  # Constants
  #-------------------------------------------------------------- ++

  MIME_TYPE = 'text/css'

  #-----------------------------------------------------------------
  # Commands
  #-------------------------------------------------------------- ++

  def rule(*patterns)
    @output << patterns.join(', ') << "\n"
    @output << '{'
    yield self
    @output << '}'
  end

  def style(name, value)
    @output << format(" %s: %s;\n", name, value)
  end
end
